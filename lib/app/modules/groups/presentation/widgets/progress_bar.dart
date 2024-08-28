import 'package:flutter/widgets.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.currentStage,
    required this.totalStage,
    required this.title,
  });

  final int currentStage;
  final int totalStage;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              t.group.create.step(count: currentStage + 1),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Palette.primary100,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 25,
              height: 1,
              color: Palette.text300,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Palette.text300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: List.generate(totalStage, (index) => index)
              .expand(
                (index) => [
                  Expanded(
                    child: Container(
                      height: 5,
                      color: index == currentStage
                          ? Palette.primary100
                          : Palette.background200,
                    ),
                  ),
                  if (index != totalStage - 1) const SizedBox(width: 5),
                ],
              )
              .toList(),
        ),
      ],
    );
  }
}
