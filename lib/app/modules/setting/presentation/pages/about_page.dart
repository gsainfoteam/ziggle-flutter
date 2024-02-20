import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/strings.dart';
import 'package:ziggle/gen/strings.g.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _controller =
      ConfettiController(duration: const Duration(microseconds: 1));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.setting.about),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirection: -pi / 2,
              numberOfParticles: 20,
              maxBlastForce: 100,
              emissionFrequency: 1,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used
            ),
          ),
          SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  title: Text(t.setting.feedback.label),
                  onTap: () {
                    sl<AnalyticsRepository>().logOpenFeedback();
                    launchUrlString(Strings.heyDeveloperUrl);
                  },
                ),
                ListTile(
                  title: Text(t.setting.termsOfService),
                  onTap: () {
                    sl<AnalyticsRepository>().logOpenTermsOfService();
                    launchUrlString(
                      Strings.termsOfServiceUrl,
                      mode: LaunchMode.inAppBrowserView,
                    );
                  },
                ),
                ListTile(
                  title: Text(t.setting.privacyPolicy),
                  onTap: () {
                    sl<AnalyticsRepository>().logOpenPrivacyPolicy();
                    launchUrlString(
                      Strings.privacyPolicyUrl,
                      mode: LaunchMode.inAppBrowserView,
                    );
                  },
                ),
                ListTile(
                  title: Text(t.setting.openSourceLicenses),
                  onTap: () => const PackagesRoute().push(context),
                ),
                ListTile(
                  title: Text(t.setting.version),
                  leadingAndTrailingTextStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  trailing: FutureBuilder(
                    future: PackageInfo.fromPlatform(),
                    builder: (_, snapshot) => Text(
                      snapshot.data?.version ?? '',
                    ),
                  ),
                ),
                ListTile(
                  title: Text(t.setting.infoteam),
                  onTap: () => _controller.play(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
