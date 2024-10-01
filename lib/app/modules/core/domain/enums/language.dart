import 'package:ziggle/gen/strings.g.dart';

enum Language {
  en,
  ko;

  static getCurrent() =>
      LocaleSettings.currentLocale == AppLocale.ko ? Language.ko : Language.en;
}
