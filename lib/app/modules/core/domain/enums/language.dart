import 'package:hive_flutter/hive_flutter.dart';
import 'package:ziggle/gen/strings.g.dart';

part 'language.g.dart';

@HiveType(typeId: 3)
enum Language {
  @HiveField(0)
  ko,
  @HiveField(1)
  en;

  static Language getCurrentLanguage() =>
      {
        AppLocale.ko: Language.ko,
        AppLocale.en: Language.en,
      }[LocaleSettings.currentLocale] ??
      Language.en;
}
