import 'package:flutter/material.dart';
import 'package:ziggle/app/common/presentaion/widgets/button.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../widgets/board_animation.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: BoardAnimation(openHidden: () {})),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  _buildText(),
                  const SizedBox(height: 100),
                  SizedBox(
                    height: 50,
                    child: ZiggleButton(
                      text: t.login.login,
                      // onTap: controller.login,
                      // loading: controller.loading.value,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ZiggleButton(
                    text: t.login.withoutLogin,
                    color: Colors.transparent,
                    // onTap: controller.skipLogin,
                    textStyle: TextStyles.link,
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    t.login.consent(
                      terms: (text) => TextSpan(
                        text: text,
                        style: const TextStyle(color: Palette.primaryColor),
                        // recognizer: TapGestureRecognizer()
                        // ..onTap = controller.openTerms,
                      ),
                    ),
                    style: TextStyles.articleCardBodyStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildText() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 100,
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    child: Assets.logo.icon.image(height: 100),
                  ),
                ],
              ),
            ),
            Assets.logo.text.image(height: 100),
          ],
        ),
        Text.rich(
          t.login.promotion(
            red: (text) => TextSpan(
              text: text,
              style: const TextStyle(color: Palette.primaryColor),
            ),
          ),
          textAlign: TextAlign.center,
          style: TextStyles.articleTitleStyle,
        )
      ],
    );
  }
}
