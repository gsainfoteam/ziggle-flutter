import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/groups/presentation/enums/group_creation_stage.dart';
import 'package:ziggle/app/modules/groups/presentation/widgets/progress_bar.dart';
import 'package:ziggle/gen/strings.g.dart';

class GroupCreationLayout extends StatelessWidget {
  const GroupCreationLayout({
    super.key,
    required this.stage,
    required this.child,
  });

  final GroupCreationStage stage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: 'appbar',
            child: AppBar(
              leadingWidth: Theme.of(context).appBarTheme.toolbarHeight,
              toolbarHeight: Theme.of(context).appBarTheme.toolbarHeight!,
              title: Text(t.group.create.title),
              leading: BackButton(
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ProgressBar(
              currentStage: GroupCreationStage.values.indexOf(stage),
              totalStage: GroupCreationStage.values.length,
              title: t.group.create.stage(context: stage),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
