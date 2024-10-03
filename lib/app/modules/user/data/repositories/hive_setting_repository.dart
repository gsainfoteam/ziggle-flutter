import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/app/modules/user/domain/repositories/developer_option_repository.dart';

import '../../domain/repositories/language_setting_repository.dart';
import '../models/setting_model.dart';

@singleton
class HiveSettingRepository
    implements LanguageSettingRepository, DeveloperOptionRepository {
  static const _boxKey = '_ziggle_3_setting';
  late final Box<SettingModel> _box;
  SettingModel get _data => _box.get(_boxKey) ?? SettingModel.init();

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    Hive.registerAdapter(SettingModelAdapter());
    _box = await Hive.openBox(_boxKey);
  }

  @override
  Future<Language> getLanguage() async {
    return Language.values.byName(_data.language);
  }

  @override
  Future<void> setLanguage(Language language) async {
    await _box.put(_boxKey, _data.copyWith(language: language.name));
  }

  @override
  Future<bool> getDeveloperOption() async {
    return _data.developerOption;
  }

  @override
  Future<void> setDeveloperOption(bool value) {
    return _box.put(_boxKey, _data.copyWith(developerOption: value));
  }
}
