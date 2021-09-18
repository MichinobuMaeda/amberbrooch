import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'conf.dart';

const bool useEmulator = String.fromEnvironment('EMULATOR') == 'Y';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFunctions functions =
    FirebaseFunctions.instanceFor(region: functionsRegion);

class FirebaseModel extends ChangeNotifier {
  bool _initialized = false;
  bool _error = false;

  void init() async {
    debugPrint('firebase: init()');
    try {
      if (useEmulator) {
        await auth.useAuthEmulator('localhost', emulatorPortAuth);
        db.useFirestoreEmulator('localhost', emulatorPortFirestore);
        await storage.useStorageEmulator('localhost', emulatorPortStorage);
        functions.useFunctionsEmulator('localhost', emulatorPortFunctions);
      }
      await Firebase.initializeApp();
      _initialized = true;
      debugPrint('firebase: initialized');
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

class Conf {
  final String _url;
  final String _version;
  final String _buildNumber;
  final DateTime _createdAt;
  final DateTime _updatedAt;

  Conf(this._url, this._version, this._buildNumber, this._createdAt,
      this._updatedAt);

  String get url => _url;
  String get version => _version;
  String get buildNumber => _buildNumber;
  DateTime get createdAt => _createdAt;
  DateTime get updatedAt => _updatedAt;
}

class ConfModel extends ChangeNotifier {
  Conf? _conf;
  bool _initialized = false;

  void listen() {
    debugPrint('conf: listen()');
    db.collection('service').doc('conf').snapshots().listen(
      (doc) {
        if (doc.exists) {
          debugPrint('conf: exists');
          _conf = Conf(
            doc.get('url'),
            doc.get('version'),
            doc.get('buildNumber'),
            doc.get('createdAt').toDate(),
            doc.get('updatedAt').toDate(),
          );
        } else {
          debugPrint('conf: null');
          _conf = null;
        }
        _initialized = true;
        notifyListeners();
      },
    );
  }

  Conf? getConf() => _conf;
  bool get initialized => _initialized;
}

class AuthUser {
  final String _id;
  String? email;
  bool emailVerified = false;

  AuthUser(this._id, this.email, this.emailVerified);

  String get id => _id;
}

class AuthModel extends ChangeNotifier {
  final FirebaseAuth _auth;
  AuthUser? _user;

  AuthModel(this._auth);

  void listen() {
    debugPrint('auth: listen()');
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        _user = null;
        debugPrint('auth: null');
      } else {
        _user = AuthUser(user.uid, user.email, user.emailVerified);
        debugPrint('auth: ' + _user!.id);
      }
      notifyListeners();
    });
  }

  AuthUser? getUser() => _user;
}
