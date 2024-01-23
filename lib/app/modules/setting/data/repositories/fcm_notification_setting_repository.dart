import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/notification_setting_repository.dart';

@Injectable(as: NotificationSettingRepository)
class FcmNotificationSettingRepository
    implements NotificationSettingRepository {
  @override
  Future<bool> isNotificationEnabled() async {
    final setting = await FirebaseMessaging.instance.getNotificationSettings();
    return setting.authorizationStatus == AuthorizationStatus.authorized;
  }

  @override
  Future<bool> enableNotification() async {
    final result = await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      provisional: true,
    );
    return result.authorizationStatus == AuthorizationStatus.authorized;
  }
}
