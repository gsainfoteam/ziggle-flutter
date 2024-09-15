import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_progress_bar.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class GroupCreationLayout extends StatelessWidget {
  const GroupCreationLayout({
    super.key,
    required this.step,
    required this.child,
  });

  final GroupCreationStep step;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: 'group creation app bar',
            child: Material(
              color: Colors.transparent,
              child: ZiggleAppBar.compact(
                backLabel: context.t.common.cancel,
                title: Text(context.t.group.creation.title),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Hero(
            tag: 'group creation title',
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Text(
                      context.t.group.creation.stage(
                          count: GroupCreationStep.values.indexOf(step) + 1),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Palette.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      color: Palette.grayText,
                      height: 1,
                      width: 25,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      context.t.group.creation.step(context: step),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Palette.grayText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: ZiggleProgressBar(
              currentStage: GroupCreationStep.values.indexOf(step),
              totalStage: GroupCreationStep.values.length,
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: SingleChildScrollView(
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 18,
                  ),
                  child: child,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
