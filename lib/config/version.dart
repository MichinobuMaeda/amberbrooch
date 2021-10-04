// on producsion build:
// $ grep "^version:" pubspec.yaml \
//     | sed 's/^version:\s*\(.*\)\s*$/const version="\1";/g' \
//     > lib/config/version.dart
const version = "1.0.0+0";
