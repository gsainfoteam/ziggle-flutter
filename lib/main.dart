import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ziggle/app.dart';
import 'package:ziggle/app/data/provider/db.dart';
import 'package:ziggle/firebase_options.dart';
import 'package:ziggle/gen/strings.g.dart';

void main() async {
  final widgetsBining = WidgetsFlutterBinding.ensureInitialized();
  final locale = LocaleSettings.useDeviceLocale();
  await initializeDateFormatting();
  Intl.defaultLocale = locale.languageCode;
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBining);
  await Future.wait([
    DbProvider.init(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
  if (!kDebugMode) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  runApp(TranslationProvider(child: const App()));
}
