import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => const SettingRoute().push(context),
            icon: Assets.icons.settings.svg(),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            _Profile(),
            Divider(),
            _NoticeSectionButton(NoticeType.written),
            _NoticeSectionButton(NoticeType.reminded),
          ],
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
      buildWhen: (_, c) => c.hasUser,
      builder: (context, state) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Palette.textGreyDark,
                  borderRadius: BorderRadius.circular(80),
                ),
                child: ClipOval(
                  child: Transform.scale(
                    alignment: const Alignment(0, -0.5),
                    scale: 1.3,
                    child: const Icon(
                      Icons.person,
                      size: 120,
                      color: Palette.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  children: [
                    _buildInfo(t.setting.name, state.user.name),
                    const SizedBox(height: 10),
                    _buildInfo(t.setting.studentId, state.user.studentId),
                    const SizedBox(height: 10),
                    _buildInfo(t.setting.email, state.user.email),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(String key, String value) {
    return Row(
      children: [
        Text(
          key,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Palette.textGreyDark,
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
    );
  }
}
