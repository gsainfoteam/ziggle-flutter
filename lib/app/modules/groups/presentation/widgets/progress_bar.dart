import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

const _gap = 5.0;

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
        Hero(
          tag: 'progress title',
          child: Material(
            color: Colors.transparent,
            child: Row(
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
          ),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) => Stack(
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
                              color: Palette.background300,
                            ),
                          ),
                          if (index != totalStage - 1)
                            const SizedBox(width: _gap),
                        ],
                      )
                      .toList(),
                ),
              ),
              Positioned(
                left: currentStage * constraints.maxWidth / 4,
                width: constraints.maxWidth / totalStage -
                    _gap / totalStage * (totalStage - 1),
                child: Hero(
                  tag: 'active progress',
                  child: Container(
                    height: 5,
                    color: Palette.primary100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
