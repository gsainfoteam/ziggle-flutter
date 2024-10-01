import 'package:ziggle/app/modules/core/domain/enums/language.dart';

abstract class LanguageSettingRepository {
  Future<Language> getLanguage();
  Future<void> setLanguage(Language language);
}
