import 'package:hive_flutter/hive_flutter.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/write_store.dart';

class DbProvider {
  static const String _settingBoxName = 'setting';
  final Box _settingBox = Hive.box(_settingBoxName);

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(WriteStoreAdapter())
      ..registerAdapter(ArticleTypeAdapter());
    await Future.wait([
      Hive.openBox(_settingBoxName),
    ]);
  }

  Future<void> setSetting(String key, dynamic value) async {
    await _settingBox.put(key, value);
  }

  Future<void> removeSetting(String key) async {
    await _settingBox.delete(key);
  }

  T getSetting<T>(String key, {T? defaultValue}) {
    return _settingBox.get(key, defaultValue: defaultValue);
  }
}
