import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ziggle/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/strings.dart';
import 'package:ziggle/gen/strings.g.dart';

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
            ListTile(
              title: Text(t.setting.notifications.label),
              onTap: () => const NotificationSettingRoute().push(context),
            ),
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
