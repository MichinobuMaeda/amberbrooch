part of amberbrooch;

// Firebase:Development
const bool useEmulator = String.fromEnvironment('EMULATOR') == 'Y';

Future<void> initFirebase(bool useEmulator) async {
  if (useEmulator) {
    await auth.useAuthEmulator('localhost', 9099);
    db.useFirestoreEmulator('localhost', 8080);
    await storage.useStorageEmulator('localhost', 9199);
    functions.useFunctionsEmulator('localhost', 5001);
  }
  await Firebase.initializeApp();
}

const String testEmail = 'primary@example.com';
const String testPassword = 'password';

// Firebase
const String functionsRegion = 'asia-northeast1';
const int reAuthExpriedMilliSec = 30 * 60 * 1000;

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFunctions functions =
    FirebaseFunctions.instanceFor(region: functionsRegion);

// Flutter
String appTitle = 'Amber brooch';

const double maxContentBodyWidth = 960.0;
const double fontSizeBody = 16.0;
const double fontSizeH1 = fontSizeBody * 2.4;
const double fontSizeH2 = fontSizeBody * 1.6;
const double fontSizeH3 = fontSizeBody * 1.3;
const double fontSizeH4 = fontSizeBody * 1.1;
const double fontSizeH5 = fontSizeBody * 1.05;
const double fontSizeH6 = fontSizeBody * 1.0;

const double buttonWidth = fontSizeBody * 7.5;
const double buttonHeight = fontSizeBody * 3;

const TextTheme textTheme = TextTheme(
  headline1: TextStyle(fontSize: fontSizeH1),
  headline2: TextStyle(fontSize: fontSizeH2),
  headline3: TextStyle(fontSize: fontSizeH3),
  headline4: TextStyle(fontSize: fontSizeH4),
  headline5: TextStyle(fontSize: fontSizeH5),
  headline6: TextStyle(fontSize: fontSizeH6),
  subtitle1: TextStyle(fontSize: fontSizeH5),
  subtitle2: TextStyle(fontSize: fontSizeBody),
  bodyText1: TextStyle(fontSize: fontSizeH5),
  bodyText2: TextStyle(fontSize: fontSizeBody),
  button: TextStyle(fontSize: fontSizeBody),
  caption: TextStyle(fontSize: fontSizeBody),
  overline: TextStyle(fontSize: fontSizeBody * 0.9),
);

final MarkdownStyleSheet markdownStyleSheet = MarkdownStyleSheet(
  h1: const TextStyle(fontSize: fontSizeH1),
  h2: const TextStyle(fontSize: fontSizeH2),
  h3: const TextStyle(fontSize: fontSizeH3),
  h4: const TextStyle(fontSize: fontSizeH4),
  h5: const TextStyle(fontSize: fontSizeH5),
  h6: const TextStyle(fontSize: fontSizeH6),
  p: const TextStyle(fontSize: fontSizeBody),
  code: const TextStyle(fontSize: fontSizeBody),
);

const ThemeMode defaultThemeMode = ThemeMode.light;
const fontFamilySansSerif = 'NotoSansJP';
const fontFamilyMonoSpace = 'RobotoMono';

final ThemeData theme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.brown,
  fontFamily: fontFamilySansSerif,
  textTheme: textTheme,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.amber,
  fontFamily: fontFamilySansSerif,
  textTheme: textTheme,
);

const Color colorSecondary = Colors.blueGrey;
const Color colorDanger = Colors.redAccent;
