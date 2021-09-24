part of amberbrooch;

const String functionsRegion = 'asia-northeast1';

const int emulatorPortAuth = 9099;
const int emulatorPortFirestore = 8080;
const int emulatorPortStorage = 9199;
const int emulatorPortFunctions = 5001;

const String testEmail = 'primary@example.com';
const String testPassword = 'password';

const String appTitle = 'Amber brooch';

const TextTheme textTheme = TextTheme(
  subtitle1: TextStyle(fontSize: 18.0), // 16.0
  subtitle2: TextStyle(fontSize: 16.0), // 14.0
  bodyText1: TextStyle(fontSize: 18.0), // 16.0
  bodyText2: TextStyle(fontSize: 16.0), // 14.0
  button: TextStyle(fontSize: 16.0), // 14.0
  caption: TextStyle(fontSize: 16.0), // 12.0
  overline: TextStyle(fontSize: 14.0), // 10.0
);

ThemeData theme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.brown,
  fontFamily: 'NotoSansJP',
  textTheme: textTheme,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.amber,
  fontFamily: 'NotoSansJP',
  textTheme: textTheme,
);

ThemeMode defaultThemeMode = ThemeMode.light;
