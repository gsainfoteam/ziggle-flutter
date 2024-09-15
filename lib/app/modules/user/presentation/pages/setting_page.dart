import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_row_button.dart';
import 'package:ziggle/app/modules/user/domain/repositories/notification_setting_repository.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/auth_bloc.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/app/values/strings.dart';
import 'package:ziggle/gen/strings.g.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: t.user.myInfo,
        title: Text(t.user.setting.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Title(title: t.user.account.title),
              ZiggleRowButton(
                title: Text(t.user.account.logout),
                destructive: true,
                showChevron: false,
                onPressed: () =>
                    context.read<AuthBloc>().add(const AuthEvent.logout()),
              ),
              const SizedBox(height: 20),
              ZiggleRowButton(
                title: Text(t.user.account.withdraw),
                destructive: true,
                showChevron: false,
                onPressed: () => launchUrlString(Strings.withdrawalUrl),
              ),
              _Title(title: t.user.setting.notification.title),
              FutureBuilder(
                future:
                    sl<NotificationSettingRepository>().isNotificationEnabled(),
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (data == null) return const SizedBox.shrink();
                  if (!data) {
                    return ZiggleRowButton(
                      title: Text(t.user.setting.notification.enable),
                      showChevron: false,
                      disabled: true,
                    );
                  }
                  return ZiggleRowButton(
                    title: Text(
                      t.user.setting.notification.enabled,
                      style: const TextStyle(color: Palette.gray),
                    ),
                    onPressed: () => sl<NotificationSettingRepository>()
                        .enableNotification(),
                  );
                },
              ),
              _Title(title: t.user.setting.language.title),
              ZiggleRowButton(
                title: Text(t.user.setting.language.setKorean),
                showChevron: false,
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              ZiggleRowButton(
                title: Text(t.user.setting.language.setEnglish),
                showChevron: false,
                onPressed: () {},
              ),
              _Title(title: t.user.setting.information.title),
              ZiggleRowButton(
                title: Text(t.user.setting.information.title),
                showChevron: false,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          color: Palette.black,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
