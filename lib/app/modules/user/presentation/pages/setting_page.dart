import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_row_button.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/app/modules/user/domain/repositories/language_setting_repository.dart';
import 'package:ziggle/app/modules/user/domain/repositories/notification_setting_repository.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/auth_bloc.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/developer_option_bloc.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/app/values/strings.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: context.t.user.myInfo,
        title: Text(context.t.user.setting.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Title(title: context.t.user.account.title),
              BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                if (state.user == null) {
                  return BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      return ZiggleButton.cta(
                        loading: authState.isLoading,
                        child: Text(context.t.user.account.login),
                        onPressed: () => context
                            .read<AuthBloc>()
                            .add(const AuthEvent.login()),
                      );
                    },
                  );
                }
                return Column(
                  children: [
                    ZiggleRowButton(
                      title: Text(context.t.user.account.logout),
                      destructive: true,
                      showChevron: false,
                      onPressed: () => context
                          .read<AuthBloc>()
                          .add(const AuthEvent.logout()),
                    ),
                    const SizedBox(height: 20),
                    ZiggleRowButton(
                      title: Text(context.t.user.account.withdraw),
                      destructive: true,
                      showChevron: false,
                      onPressed: () => launchUrlString(Strings.withdrawalUrl),
                    ),
                  ],
                );
              }),
              _Title(title: context.t.user.setting.notification.title),
              FutureBuilder(
                future:
                    sl<NotificationSettingRepository>().isNotificationEnabled(),
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (data == null) return const SizedBox.shrink();
                  if (!data) {
                    return ZiggleRowButton(
                      title: Text(context.t.user.setting.notification.enable),
                      onPressed: () => sl<NotificationSettingRepository>()
                          .enableNotification(),
                    );
                  }
                  return ZiggleRowButton(
                    title: Text(context.t.user.setting.notification.enabled),
                    disabled: true,
                    showChevron: false,
                  );
                },
              ),
              _Title(title: context.t.user.setting.language.title),
              ZiggleRowButton(
                title: Text(context.t.user.setting.language.setKorean),
                showChevron: false,
                onPressed: () {
                  LocaleSettings.setLocale(AppLocale.ko);
                  sl<LanguageSettingRepository>().setLanguage(Language.ko);
                },
              ),
              const SizedBox(height: 20),
              ZiggleRowButton(
                title: Text(context.t.user.setting.language.setEnglish),
                showChevron: false,
                onPressed: () {
                  LocaleSettings.setLocale(AppLocale.en);
                  sl<LanguageSettingRepository>().setLanguage(Language.en);
                },
              ),
              _Title(title: context.t.user.setting.information.title),
              ZiggleRowButton(
                title: Text(context.t.user.setting.information.title),
                onPressed: () => const InformationRoute().push(context),
              ),
              BlocBuilder<DeveloperOptionBloc, DeveloperOptionState>(
                builder: (context, state) => state.enabled
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _Title(title: context.t.user.developMode.title),
                          ZiggleRowButton(
                            showChevron: false,
                            title: Text(context.t.user.developMode.disable),
                            onPressed: () => context
                                .read<DeveloperOptionBloc>()
                                .add(const DeveloperOptionEvent.disable()),
                          ),
                          const SizedBox(height: 20),
                          ZiggleRowButton(
                            showChevron: false,
                            title: Text(
                              context.t.user.developMode.toggleChannel(
                                channel: state.apiChannel.name,
                              ),
                            ),
                            onPressed: () {
                              context.read<DeveloperOptionBloc>().add(
                                  const DeveloperOptionEvent.toggleChannel());
                              context.router.replaceAll([
                                SplashRoute(delay: true),
                              ]);
                            },
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
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
