import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/strings.dart';
import 'package:ziggle/gen/strings.g.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.setting.about),
      ),
      body: SingleChildScrollView(
        child: ListBody(
          children: [
            ListTile(
              title: Text(t.setting.feedback.label),
              onTap: () => launchUrlString(Strings.heyDeveloperUrl),
            ),
            ListTile(
              title: Text(t.setting.termsOfService),
              onTap: () => launchUrlString(
                Strings.termsOfServiceUrl,
                mode: LaunchMode.inAppBrowserView,
              ),
            ),
            ListTile(
              title: Text(t.setting.privacyPolicy),
              onTap: () => launchUrlString(
                Strings.privacyPolicyUrl,
                mode: LaunchMode.inAppBrowserView,
              ),
            ),
            ListTile(
              title: Text(t.setting.openSourceLicenses),
              onTap: () => const PackagesRoute().push(context),
            ),
            ListTile(
              title: Text(t.setting.version),
              trailing: FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (_, snapshot) => Text(snapshot.data?.version ?? ''),
              ),
            ),
            ListTile(
              title: Text(t.setting.infoteam),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
