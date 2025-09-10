import 'package:injectable/injectable.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/core/data/data_sources/object_box.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/app/modules/user/data/models/setting_model.dart';
import 'package:ziggle/app/modules/user/domain/repositories/developer_option_repository.dart';
import 'package:ziggle/app/modules/user/domain/repositories/language_setting_repository.dart';
import 'package:ziggle/objectbox.g.dart';

@singleton
class ObjectboxSettingRepository
    implements LanguageSettingRepository, DeveloperOptionRepository {
  final ObjectBox objectBox = sl<ObjectBox>();
  late final Box<SettingModel> _box;
  SettingModel get _data => _box.get(1) ?? SettingModel.init();

  ObjectboxSettingRepository() {
    _box = objectBox.store.box<SettingModel>();
  }

  @override
  Future<Language> getLanguage() async {
    return Language.values.byName(_data.language);
  }

  @override
  Future<void> setLanguage(Language language) async {
    final setting = _data.copyWith(language: language.name);
    _box.put(SettingModel(
      id: setting.id == 0 ? 0 : setting.id,
      language: setting.language,
      developerOption: setting.developerOption,
    ));
  }

  @override
  Future<bool> getDeveloperOption() async {
    return _data.developerOption;
  }

  @override
  Future<void> setDeveloperOption(bool value) async {
    final setting = _data.copyWith(developerOption: value);
    _box.put(SettingModel(
      id: setting.id == 0 ? 0 : setting.id,
      language: setting.language,
      developerOption: setting.developerOption,
    ));
  }
}
