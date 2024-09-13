import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_row_button.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Column(
              children: [
                const _Login(),
                const SizedBox(height: 40),
                ZiggleRowButton(
                  icon: Assets.icons.setting.svg(),
                  title: Text(t.user.setting.title),
                  onPressed: () {},
                ),
                const SizedBox(height: 20),
                ZiggleRowButton(
                  icon: Assets.icons.flag.svg(),
                  title: Text(t.user.feedback),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
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
          onPressed: () {},
          child: Text(t.user.login.action),
        ),
      ],
    );
  }
}
