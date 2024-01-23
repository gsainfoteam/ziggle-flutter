abstract class NotificationSettingRepository {
  Future<bool> isNotificationEnabled();
  Future<bool> enableNotification();
}
