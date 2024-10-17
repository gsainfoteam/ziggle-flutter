import 'dart:convert';
import 'dart:io';

import 'package:gsheets/gsheets.dart';

const defaultLanguage = 'en';
const defaultNamespaces = ['common', 'group', 'notice', 'user'];
const encoder = JsonEncoder.withIndent("  ");

void main(List<String> args) async {
  final env = await File('.env').readAsString();
  final envs = env.split('\n');
  String getEnv(String key) => envs
      .firstWhere((element) => element.startsWith('$key='))
      .split('=')
      .sublist(1)
      .join('=');
  final spreadsheetId = getEnv('SPREADSHEET_ID');

  final gSheets = GSheets(
    utf8.decode(base64.decode(getEnv('GOOGLE_CREDENTIAL_JSON'))),
  );
  final sheet = await gSheets.spreadsheet(spreadsheetId);
  final selectedSheets = sheet.sheets.where(
      (n) => defaultNamespaces.contains(n.title) || args.contains(n.title));
  final result = await Future.wait(selectedSheets.map((sheet) async {
    final [header, ...body] = await sheet.values.allRows();
    final languages = header.sublist(2);
    final data = body.map((row) => Map.fromIterables(header, row));
    final map = languages
        .map(
          (language) => MapEntry(
            language,
            data.fold(
              <String, dynamic>{},
              (previousValue, element) {
                final key = element['key'] as String;
                final value = element[language]!;
                final keys = key.split('.');
                Map<String, dynamic> nestedMap = previousValue;
                for (int i = 0; i < keys.length - 1; i++) {
                  nestedMap =
                      nestedMap.putIfAbsent(keys[i], () => <String, dynamic>{});
                }
                nestedMap[keys.last] = value.replaceAll('\\n', '\n');
                return previousValue;
              },
            ),
          ),
        )
        .map((e) => MapEntry(e.key, encoder.convert(e.value)));
    return MapEntry(sheet.title, Map.fromEntries(map));
  }));
  final output = Map.fromEntries(result);

  final outputDir = Directory('assets/i18n');

  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  output.forEach((key, value) {
    value.forEach((language, value) {
      if (language == defaultLanguage) {
        final file = File('${outputDir.path}/$key.i18n.json');
        file.writeAsStringSync(value);
        return;
      }
      final file = File('${outputDir.path}/${key}_$language.i18n.json');
      file.writeAsStringSync(value);
    });
  });
}
