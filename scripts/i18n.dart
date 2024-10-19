// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:gsheets/gsheets.dart';

const defaultLanguage = 'en';
const defaultNamespaces = ['common'];
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
  final sheets =
      await Future.wait(selectedSheets.map((sheet) => sheet.values.allRows()));
  final languages = sheets.first.first.sublist(2);

  final result = Map.fromEntries(languages.map((language) => MapEntry(
      language,
      sheets.expand((rows) {
        final [header, ...body] = rows;
        return body
            .where((row) => row.length == header.length)
            .map((row) => Map.fromIterables(header, row));
      }).fold(<String, dynamic>{}, (prev, element) {
        final key = element['key'] as String;
        final value = element[language];
        if (value == null || value.isEmpty) {
          print('Value is null for key: $key in language: $language');
          return prev;
        }
        final keys = key.split('.');
        Map<String, dynamic> nestedMap = prev;
        for (int i = 0; i < keys.length - 1; i++) {
          nestedMap = nestedMap.putIfAbsent(keys[i], () => <String, dynamic>{});
        }
        nestedMap[keys.last] = value.replaceAll('\\n', '\n');
        return prev;
      }))));

  final outputDir = Directory('assets/i18n');

  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  await Future.forEach(await outputDir.list().toList(), (file) {
    if (file is File) {
      file.deleteSync();
    }
  });

  result.forEach((language, value) {
    final file = File(language == defaultLanguage
        ? '${outputDir.path}/strings.i18n.json'
        : '${outputDir.path}/strings_$language.i18n.json');
    file.writeAsStringSync(encoder.convert(value));
  });
}
