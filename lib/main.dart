import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';

const useEmulator = String.fromEnvironment('EMULATOR');
const String functionRegion = 'asia-northeast1';
final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFunctions functions =
    FirebaseFunctions.instanceFor(region: functionRegion);

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _firebaseInitialized = false;
  bool _firebaseError = false;

  void initializeFlutterFire() async {
    try {
      if (useEmulator == 'Y') {
        await auth.useAuthEmulator('localhost', 9099);
        db.useFirestoreEmulator('localhost', 8080);
        await storage.useStorageEmulator('localhost', 9199);
        functions.useFunctionsEmulator('localhost', 5001);
      }
      await Firebase.initializeApp();
      setState(() {
        _firebaseInitialized = true;
      });
    } catch (e) {
      setState(() {
        _firebaseError = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              useEmulator == 'Y' ? 'Use emulator' : 'Production mode',
            ),
            Text(
              _firebaseInitialized
                  ? 'Firebase initialized'
                  : _firebaseError
                      ? 'Firebase error'
                      : 'Firebase initialzing',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
