import 'package:cookie_jar/cookie_jar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ziggle/app.dart';
import 'package:ziggle/app/core/theme/font.dart';
import 'package:ziggle/app/data/provider/db.dart';
import 'package:ziggle/app_bloc_observer.dart';
import 'package:ziggle/firebase_options.dart';
import 'package:ziggle/gen/strings.g.dart';

void main() async {
  _initSplash();
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
    DbProvider.init(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    Get.putAsync<CookieJar>(() async {
      final appDocDir = await getApplicationDocumentsDirectory();
      final appDocPath = appDocDir.path;
      return PersistCookieJar(
        ignoreExpires: true,
        storage: FileStorage("$appDocPath/.cookies/"),
      );
    })
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
