import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/strings.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/repositories/notification_setting_repository.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.setting.title),
      ),
      body: SingleChildScrollView(
        child: ListBody(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                t.setting.account.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text(t.setting.account.logout),
              onTap: () {
                context.read<AuthBloc>().add(const AuthEvent.logout());
                const FeedRoute().go(context);
              },
            ),
            ListTile(
              title: Text(t.setting.account.withdraw),
              onTap: () => launchUrlString(Strings.withdrawalUrl),
            ),
            const Divider(),
            const _NotificationSetting(),
            const Divider(),
            ListTile(
              title: Text(t.setting.about),
              onTap: () => const AboutRoute().push(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationSetting extends StatelessWidget {
  const _NotificationSetting();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            t.setting.notifications.label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        FutureBuilder(
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
            return ListTile(
              title: Text(t.setting.notifications.enabled),
              onTap: () {},
            );
          },
        ),
      ],
    );
  }
}
