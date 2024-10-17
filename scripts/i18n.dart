// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:gsheets/gsheets.dart';

const defaultLanguage = 'en';
const defaultNamespaces = ['common', 'group', 'notice', 'user'];
const encoder = JsonEncoder.withIndent("  ");

Future<void> main(List<String> args) async {
  final env = DotEnv()..load();
  final spreadsheetId = env['SPREADSHEET_ID']!;
  final gSheets = GSheets(
    utf8.decode(base64.decode(env['GOOGLE_CREDENTIAL_JSON']!)),
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
                final value = element[language];
                if (value == null || value.isEmpty) {
                  print('Value is null for key: $key in language: $language');
                  return previousValue;
                }
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
