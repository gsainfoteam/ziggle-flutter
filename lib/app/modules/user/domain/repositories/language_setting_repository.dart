import 'package:ziggle/gen/strings.g.dart';

abstract class LanguageSettingRepository {
  Future<AppLocale> getLanguage();
  Future<void> setLanguage(AppLocale language);
}
