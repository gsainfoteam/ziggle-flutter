import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ziggle/app.dart';
import 'package:ziggle/app/data/provider/db.dart';
import 'package:ziggle/firebase_options.dart';

void main() async {
  await initializeDateFormatting('ko_KR', null);
  Intl.defaultLocale = 'ko_KR';
  final widgetsBining = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBining);
  await Future.wait([
    DbProvider.init(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
  runApp(const App());
}
