import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/app.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/gen/strings.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await _initLocale();
  runApp(TranslationProvider(child: const App()));
}

Future<void> _initLocale() async {
  final locale = LocaleSettings.useDeviceLocale();
  LocaleSettings.setLocale(locale);
  await initializeDateFormatting();
  Intl.defaultLocale = locale.languageCode;
  LocaleSettings.setPluralResolver(
    locale: AppLocale.ko,
    cardinalResolver: (n, {few, many, one, other, two, zero}) =>
        other ?? n.toString(),
    ordinalResolver: (n, {few, many, one, other, two, zero}) =>
        other ?? n.toString(),
  );
}
