abstract class SettingsRepository {
  Future<void> setSetting(String key, dynamic value);
  Future<void> removeSetting(String key);
  T getSetting<T>(String key, {T? defaultValue});
}
