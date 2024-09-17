import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/router/routes.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ZiggleButton.cta(
      onPressed: () => const GroupDetailRoute().go(context),
      child: const Text('feed page'),
    );
  }
}
