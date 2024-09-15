import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/repositories/language_setting_repository.dart';
import '../models/setting_model.dart';

@singleton
class HiveSettingRepository implements LanguageSettingRepository {
  static const _boxKey = '_ziggle_3_setting';
  late final Box<SettingModel> _box;
  SettingModel get _data => _box.get(_boxKey) ?? SettingModel.init();

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    Hive.registerAdapter(SettingModelAdapter());
    _box = await Hive.openBox(_boxKey);
  }

  @override
  Future<AppLocale> getLanguage() async {
    return AppLocale.values.byName(_data.language);
  }

  @override
  Future<void> setLanguage(AppLocale language) async {
    await _box.put(_boxKey, _data.copyWith(language: language.name));
  }
}
