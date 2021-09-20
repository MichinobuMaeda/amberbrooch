import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import "package:universal_html/html.dart";
import 'package:package_info_plus/package_info_plus.dart';
import 'conf.dart';

const bool useEmulator = String.fromEnvironment('EMULATOR') == 'Y';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFunctions functions =
    FirebaseFunctions.instanceFor(region: functionsRegion);

class Conf {
  final String url;
  final String version;
  final String buildNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conf({
    required this.url,
    required this.version,
    required this.buildNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  operator ==(Object other) =>
      other is Conf &&
      other.url == url &&
      other.version == version &&
      other.buildNumber == buildNumber &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

  @override
  int get hashCode => hashValues(
        url,
        version,
        buildNumber,
        createdAt,
        updatedAt,
      );
}

class ConfModel extends ChangeNotifier {
  Conf? _conf;
  bool _initialized = false;

  void listen() {
    debugPrint('conf: listen()');
    db.collection('service').doc('conf').snapshots().listen(
      (doc) {
        _initialized = true;
        if (doc.exists) {
          debugPrint('conf: exists');
          Conf provided = Conf(
            url: doc.get('url'),
            version: doc.get('version'),
            buildNumber: doc.get('buildNumber'),
            createdAt: doc.get('createdAt').toDate(),
            updatedAt: doc.get('updatedAt').toDate(),
          );
          if (_conf != provided) {
            _conf = provided;
            notifyListeners();
          }
        } else {
          debugPrint('conf: null');
          if (_conf != null) {
            _conf = null;
            notifyListeners();
          }
        }
      },
    );
  }

  Conf? getConf() => _conf;
  bool get initialized => _initialized;
}

class AuthUser {
  final String id;
  String? email;
  bool? emailVerified = false;

  AuthUser({required this.id, this.email, this.emailVerified});

  @override
  operator ==(Object other) =>
      other is AuthUser &&
      other.id == id &&
      other.email == email &&
      other.emailVerified == emailVerified;

  @override
  int get hashCode => hashValues(id, email, emailVerified);
}

class AuthModel extends ChangeNotifier {
  final FirebaseAuth _auth;
  AuthUser? _user;

  AuthModel(this._auth);

  void listen() {
    debugPrint('auth: listen()');
    _auth.authStateChanges().listen((User? user) {
      _updateUser(user);
    });
  }

  Future<void> reload() async {
    if (auth.currentUser != null) {
      await auth.currentUser!.reload();
      _updateUser(auth.currentUser);
    }
  }

  void _updateUser(User? user) {
    if (user == null) {
      if (_user != null) {
        _user = null;
        debugPrint('auth: null');
        notifyListeners();
      }
    } else {
      AuthUser provided = AuthUser(
        id: user.uid,
        email: user.email,
        emailVerified: user.emailVerified,
      );
      if (_user != provided) {
        _user = provided;
        debugPrint('auth: ' + _user!.id);
        notifyListeners();
      }
    }
  }

  AuthUser? getUser() => _user;
}

class FirebaseModel extends ChangeNotifier {
  bool _initialized = false;
  bool _error = false;

  FirebaseModel();

  void init({required String deepLink}) async {
    debugPrint('firebase: init()');
    try {
      if (useEmulator) {
        await auth.useAuthEmulator('localhost', emulatorPortAuth);
        db.useFirestoreEmulator('localhost', emulatorPortFirestore);
        await storage.useStorageEmulator('localhost', emulatorPortStorage);
        functions.useFunctionsEmulator('localhost', emulatorPortFunctions);
      }
      await Firebase.initializeApp();
      auth.setLanguageCode('ja');
      _initialized = true;
      debugPrint('firebase: initialized');

      String? email = window.localStorage['amberbrooch_email'];
      window.localStorage['amberbrooch_email'] = '';

      debugPrint(deepLink);
      debugPrint(email);
      if (auth.isSignInWithEmailLink(deepLink)) {
        if (RegExp(r'reauthenticate=yes').hasMatch(deepLink)) {
          // AuthCredential credential = EmailAuthProvider.credentialWithLink(
          //     email: email ?? '', emailLink: deepLink);
          // _tempCredential = await auth.currentUser
          //     ?.reauthenticateWithCredential(credential);
          // appContents = AppContents.me;
        } else {
          await auth.signInWithEmailLink(
            email: email ?? '',
            emailLink: deepLink,
          );
        }
      }

      notifyListeners();
    } catch (e, s) {
      if (e.toString().contains('code=failed-precondition')) {
        _initialized = true;
        debugPrint('firebase: already initialized');
      } else {
        _error = true;
        debugPrint('firebase: error');
        debugPrint('Exception: $e');
        debugPrint('StackTrace: $s');
      }
      notifyListeners();
    }
  }

  bool get initialized => _initialized;
  bool get error => _error;
}

class ClientModel extends ChangeNotifier {
  final String deepLink;
  late PackageInfo packageInfo;

  ClientModel({required this.deepLink});

  void init() async {
    packageInfo = await PackageInfo.fromPlatform();
  }
}

class ThemeModeModel extends ChangeNotifier {
  ThemeMode _mode = defaultThemeMode;

  set mode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }

  ThemeMode get mode => _mode;
}
