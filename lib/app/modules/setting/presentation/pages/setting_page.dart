import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
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
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) => state.hasUser
                  ? ListBody(
                      children: [
                        ListTile(
                          title: Text(t.setting.account.logout),
                          onTap: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEvent.logout());
                            const FeedRoute().go(context);
                          },
                        ),
                        ListTile(
                          title: Text(t.setting.account.withdraw),
                          onTap: () {
                            sl<AnalyticsRepository>().logOpenWithdrawal();
                            launchUrlString(Strings.withdrawalUrl);
                          },
                        ),
                      ],
                    )
                  : ListBody(
                      children: [
                        ListTile(
                          title: Text(t.setting.notLoggedIn.action),
                          selected: state.isLoading,
                          selectedTileColor: Palette.backgroundGreyLight,
                          onTap: state.isLoading
                              ? null
                              : () => context
                                  .read<AuthBloc>()
                                  .add(const AuthEvent.login()),
                        ),
                      ],
                    ),
            ),
            const Divider(),
            const _NotificationSetting(),
            const Divider(),
            const _LanguageSetting(),
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

class _LanguageSetting extends StatelessWidget {
  const _LanguageSetting();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            t.setting.language.label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          title: Text(t.setting.language.korean),
          onTap: () {
            LocaleSettings.setLocale(AppLocale.ko);
            const FeedRoute().go(context);
          },
        ),
        ListTile(
          title: Text(t.setting.language.english),
          onTap: () {
            LocaleSettings.setLocale(AppLocale.en);
            const FeedRoute().go(context);
          },
        ),
      ],
    );
  }
}
