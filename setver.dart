import 'dart:convert';
import 'dart:io';

void main() async {
  try {
    final RegExp exp = RegExp(r"\nversion:\s*(.+)\+(.+)\n");
    String contents = await File('pubspec.yaml').readAsString();
    RegExpMatch? matches = exp.firstMatch(contents);
    final version = matches!.group(1);
    final buildNumber = matches.group(2);
    String jsonText = jsonEncode({
      'version': version,
      'buildNumber': buildNumber,
    });
    await File('build/web/version.json').writeAsString(jsonText);
  } catch (e) {
    exit(1);
  }
}
