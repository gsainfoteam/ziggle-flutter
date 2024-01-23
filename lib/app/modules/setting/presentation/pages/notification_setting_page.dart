import 'package:flutter/material.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/repositories/notification_setting_repository.dart';

class NotificationSettingPage extends StatelessWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.setting.notifications.label),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: sl<NotificationSettingRepository>().isNotificationEnabled(),
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (data == null) return const SizedBox.shrink();
            if (!data) {
              return ListTile(
                title: Text(t.setting.notifications.disabled.title),
                subtitle: Text(t.setting.notifications.disabled.description),
                trailing: Text(t.setting.notifications.disabled.action),
                onTap: () =>
                    sl<NotificationSettingRepository>().enableNotification(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
