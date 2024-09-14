import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_row_button.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/auth_bloc.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: _Layout(),
          ),
        ),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      buildWhen: (_, c) => c.mapOrNull(done: (v) => true) ?? false,
      builder: (context, state) {
        final authenticated = state.user != null;
        return Column(
          children: [
            if (authenticated)
              _Profile(user: state.user!)
            else
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (c, p) => p.isLoading,
                builder: (context, authState) => Stack(
                  alignment: Alignment.center,
                  children: [
                    ImageFiltered(
                      enabled: authState.isLoading,
                      imageFilter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                        tileMode: TileMode.decal,
                      ),
                      child: const _Login(),
                    ),
                    if (authState.isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                  ],
                ),
              ),
            const SizedBox(height: 40),
            ZiggleRowButton(
              icon: Assets.icons.setting.svg(),
              title: Text(t.user.setting.title),
              onPressed: () => const SettingRoute().push(context),
            ),
            const SizedBox(height: 20),
            ZiggleRowButton(
              icon: Assets.icons.flag.svg(),
              title: Text(t.user.feedback),
              onPressed: () {},
            ),
            const SizedBox(height: 40),
            if (authenticated)
              ZiggleRowButton(
                showChevron: false,
                title: Text(t.user.logout),
                destructive: true,
                onPressed: () =>
                    context.read<AuthBloc>().add(const AuthEvent.logout()),
              ),
          ],
        );
      },
    );
  }
}

class _Profile extends StatelessWidget {
  const _Profile({required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Assets.images.defaultProfile.image(width: 120),
        const SizedBox(height: 10),
        Text(
          user.name,
          style: const TextStyle(
            color: Palette.black,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          user.email,
          style: const TextStyle(
            color: Palette.grayText,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _Login extends StatelessWidget {
  const _Login();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          t.user.login.title,
          style: const TextStyle(
            fontSize: 24,
            color: Palette.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          t.user.login.description,
          style: const TextStyle(
            fontSize: 14,
            color: Palette.grayText,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        ZiggleButton.cta(
          onPressed: () =>
              context.read<AuthBloc>().add(const AuthEvent.login()),
          child: Text(t.user.login.action),
        ),
      ],
    );
  }
}
