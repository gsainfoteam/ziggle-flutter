import 'package:flutter/material.dart';
import 'package:ziggle/app/router/routes.dart';
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
              title: Text(t.setting.about),
              onTap: () => const AboutRoute().push(context),
            ),
          ],
        ),
      ),
    );
  }
}
