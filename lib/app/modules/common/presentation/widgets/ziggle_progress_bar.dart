import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

const _gap = 5.0;

class ZiggleProgressBar extends StatelessWidget {
  const ZiggleProgressBar({
    super.key,
    required this.currentStage,
    required this.totalStage,
  });

  final int currentStage;
  final int totalStage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveMaxWidth =
            (constraints.maxWidth - (totalStage - 1) * _gap);
        final width = effectiveMaxWidth / totalStage;
        return Stack(
          children: [
            Hero(
              tag: 'progress background',
              child: Row(
                children: List.generate(totalStage, (index) => index)
                    .expand(
                      (index) => [
                        Expanded(
                          child: Container(
                            height: 5,
                            color: Palette.grayLight,
                          ),
                        ),
                        if (index != totalStage - 1)
                          const SizedBox(width: _gap),
                      ],
                    )
                    .toList(),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuad,
              left: (width + _gap) * currentStage,
              width: width,
              child: Hero(
                tag: 'active progress',
                child: Container(
                  height: 5,
                  color: Palette.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
