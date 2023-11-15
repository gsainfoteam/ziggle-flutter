import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/app.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/core/themes/font.dart';
import 'package:ziggle/app_bloc_observer.dart';
import 'package:ziggle/firebase_options.dart';
import 'package:ziggle/gen/strings.g.dart';

void main() async {
  _initSplash();
  await configureDependencies();
  await _preInit();
  _initCrashlytics();
  _initFont();
  _initBloc();
  runApp(TranslationProvider(child: const App()));
}

void _initSplash() {
  final widgetsBining = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBining);
}

Future<void> _initLocale() async {
  final locale = LocaleSettings.useDeviceLocale();
  await initializeDateFormatting();
  Intl.defaultLocale = locale.languageCode;
}

Future<void> _preInit() async {
  await Future.wait([
    _initLocale(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
}

void _initCrashlytics() {
  if (kReleaseMode) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}

void _initFont() {
  Pretendard.register();
}

void _initBloc() {
  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }
}
