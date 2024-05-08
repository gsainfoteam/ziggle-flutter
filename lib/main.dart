import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/app.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/setting/domain/repositories/language_setting_repository.dart';
import 'package:ziggle/app/values/emojis.dart';
import 'package:ziggle/app/values/fonts.dart';
import 'package:ziggle/app_bloc_observer.dart';
import 'package:ziggle/firebase_options.dart';
import 'package:ziggle/gen/strings.g.dart';

void main() async {
  _initSplash();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _initCrashlytics();
  await _initHive();
  await configureDependencies();
  await _initLocale();
  _initFont();
  _initBloc();
  runApp(TranslationProvider(child: const App()));
}

void _initSplash() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
}

Future<void> _initLocale() async {
  final locale = await sl<LanguageSettingRepository>().getLanguage();
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

Future<void> _initHive() async {
  await Hive.initFlutter();
}

void _initFont() {
  Pretendard.register();
  Emojis.register();
}

void _initBloc() {
  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }
}
