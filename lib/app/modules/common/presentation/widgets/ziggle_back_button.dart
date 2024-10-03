import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class ZiggleBackButton extends StatelessWidget {
  const ZiggleBackButton({
    super.key,
    required this.label,
    this.from = PageSource.unknown,
  });

  final PageSource from;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ZiggleButton.text(
      onPressed: () {
        AnalyticsRepository.click(AnalyticsEvent.back(from));
        context.maybePop();
      },
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Assets.icons.navArrowLeft.svg(width: 24, height: 24),
            ),
            TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 16,
                color: Palette.primary,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
