import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/groups/presentation/enums/group_creation_step.dart';

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
          Expanded(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(),
                child: child,
              ),
            ),
          )
        ],
      ),
    );
  }
}
