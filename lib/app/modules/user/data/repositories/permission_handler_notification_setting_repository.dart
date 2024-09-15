import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/repositories/notification_setting_repository.dart';

@Injectable(as: NotificationSettingRepository)
class PermissionHandlerNotificationSettingRepository
    implements NotificationSettingRepository {
  @override
  Future<bool> isNotificationEnabled() async {
    return await Permission.notification.isGranted;
  }

  Future<bool> _needsOpenSetting() async {
    final status = await Permission.notification.status;
    return status.isDenied ||
        status.isPermanentlyDenied ||
        status.isProvisional;
  }

  @override
  Future<bool> enableNotification() async {
    final needsOpenSetting = await _needsOpenSetting();
    if (needsOpenSetting) {
      await openAppSettings();
      return false;
    }
    final result = await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      provisional: true,
    );
    return result.authorizationStatus == AuthorizationStatus.authorized;
  }
}
