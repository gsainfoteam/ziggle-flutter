import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/settings_repository.dart';
import 'package:ziggle/app/modules/notices/data/models/notice_write_model.dart';

@Singleton(as: SettingsRepository)
class HiveSettingsRepository implements SettingsRepository {
  final String _settingBoxName = 'setting';
  late final Box _settingBox = Hive.box(_settingBoxName);

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(NoticeWriteModelImplAdapter());
    await Future.wait([
      Hive.openBox(_settingBoxName).catchError((_) async {
        await Hive.deleteBoxFromDisk(_settingBoxName);
        return Hive.openBox(_settingBoxName);
      }),
    ]);
  }

  @override
  T getSetting<T>(String key, {T? defaultValue}) {
    return _settingBox.get(key, defaultValue: defaultValue);
  }

  @override
  Future<void> removeSetting(String key) async {
    await _settingBox.delete(key);
  }

  @override
  Future<void> setSetting(String key, value) async {
    await _settingBox.put(key, value);
  }
}
