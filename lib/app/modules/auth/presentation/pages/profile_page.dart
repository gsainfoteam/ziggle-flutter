import 'package:flutter/material.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/gen/assets.gen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => const SettingRoute().push(context),
            icon: Assets.icons.settings.image(),
          ),
        ],
      ),
    );
  }
}
