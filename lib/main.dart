import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ziggle/app.dart';
import 'package:ziggle/app/data/provider/db.dart';

void main() async {
  await initializeDateFormatting('ko_KR', null);
  Intl.defaultLocale = 'ko_KR';
  final widgetsBining = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBining);
  await DbProvider.init();
  runApp(const App());
}
