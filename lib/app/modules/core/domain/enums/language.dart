import 'package:ziggle/gen/strings.g.dart';

enum Language {
  ko,
  en;

  static Language getCurrentLanguage() =>
      {
        AppLocale.ko: Language.ko,
        AppLocale.en: Language.en,
      }[LocaleSettings.currentLocale] ??
      Language.en;
}
