import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/app/values/strings.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.setting.mypage),
        actions: [
          IconButton(
            onPressed: () => const SettingRoute().push(context),
            icon: Assets.icons.settings.svg(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) => state.hasUser
              ? const Column(
                  children: [
                    _Profile(),
                    _FeedbackButton(),
                    Divider(),
                    _NoticeSectionButton(NoticeType.written),
                    _NoticeSectionButton(NoticeType.reminded),
                    Divider(),
                  ],
                )
              : const Column(
                  children: [
                    _Login(),
                    Divider(),
                    _FeedbackButton(),
                  ],
                ),
        ),
      ),
    );
  }
}

class _Profile extends StatelessWidget {
  const _Profile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Assets.images.defaultProfile.image(width: 75),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfo(state.user.name, 22, Palette.black, FontWeight.w800),
                _buildInfo(state.user.studentId),
                _buildInfo(state.user.email, 14, Palette.textGreyDark,
                    FontWeight.w400),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String value,
      [double? fontSize = 14,
      Color? color = Palette.black,
      FontWeight? fontWeight = FontWeight.w500]) {
    return Row(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
          ),
        ),
      ],
    );
  }
}

class _NoticeSectionButton extends StatelessWidget {
  const _NoticeSectionButton(this.type);
  final NoticeType type;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: type.icon.svg(),
      title: Text(type.label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            t.notice.viewList,
            style: const TextStyle(fontSize: 14, color: Palette.textGrey),
          ),
          const Icon(Icons.chevron_right, color: Palette.textGrey),
        ],
      ),
      onTap: () => SectionRoute(type: type).push(context),
      splashColor: Colors.transparent,
    );
  }
}

class _Login extends StatelessWidget {
  const _Login();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.setting.notLoggedIn.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(t.setting.notLoggedIn.description),
          const SizedBox(height: 10),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) => ZiggleButton(
              text: t.setting.notLoggedIn.action,
              onTap: () =>
                  context.read<AuthBloc>().add(const AuthEvent.login()),
              loading: state.maybeWhen(
                orElse: () => false,
                loading: () => true,
              ),
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  const _FeedbackButton();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Assets.icons.flag.svg(),
      title: Text(
        t.setting.feedbackReport,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            t.setting.open,
            style: const TextStyle(fontSize: 14, color: Palette.textGrey),
          ),
          const Icon(Icons.chevron_right, color: Palette.textGrey),
        ],
      ),
      onTap: () => launchUrlString(Strings.heyDeveloperUrl),
      splashColor: Colors.transparent,
    );
  }
}
