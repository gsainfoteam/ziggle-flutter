import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/app/modules/user/data/models/setting_model.dart';
import 'package:ziggle/app/modules/user/domain/repositories/developer_option_repository.dart';
import 'package:ziggle/app/modules/user/domain/repositories/language_setting_repository.dart';
import 'package:ziggle/objectbox.g.dart';

@singleton
class ObjectboxSettingRepository
    implements LanguageSettingRepository, DeveloperOptionRepository {
  static const _boxKey = '_ziggle_3_setting';
  late final Box<SettingModel> _box;
  SettingModel get _data => _box.get(0) ?? SettingModel.init();

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    final Store store = await openStore(directory: _boxKey);
    _box = store.box<SettingModel>();
  }

  @override
  Future<Language> getLanguage() async {
    return Language.values.byName(_data.language);
  }

  @override
  Future<void> setLanguage(Language language) async {
    _box.put(_data.copyWith(language: language.name));
  }

  @override
  Future<bool> getDeveloperOption() async {
    return _data.developerOption;
  }

  @override
  Future<void> setDeveloperOption(bool value) async {
    _box.put(_data.copyWith(developerOption: value));
  }
}
