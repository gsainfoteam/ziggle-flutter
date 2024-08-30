import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_button_2.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/groups/presentation/enums/group_creation_stage.dart';
import 'package:ziggle/app/modules/groups/presentation/widgets/progress_bar.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class GroupCreationNamePage extends StatelessWidget {
  const GroupCreationNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Theme.of(context).appBarTheme.toolbarHeight,
        title: Text(t.group.create.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProgressBar(
                currentStage: 0,
                totalStage: 4,
                title:
                    t.group.create.stage(context: GroupCreationStage.profile),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _ProfileSetting(
                  onNext: () =>
                      const GroupCreationRoute(GroupCreationStage.introduce)
                          .push(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileSetting extends StatefulWidget {
  const _ProfileSetting({required this.onNext});

  final VoidCallback onNext;

  @override
  State<_ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<_ProfileSetting> {
  String _name = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Assets.images.defaultGroupProfile.image(width: 300),
                  const SizedBox(height: 24),
                  ZiggleButton2(
                    onPressed: () {},
                    child: Text(t.group.create.setGroupProfileImage),
                  ),
                  const SizedBox(height: 60),
                  ZiggleTextField(
                    label: t.group.create.groupName.label,
                    hint: t.group.create.groupName.hint,
                    onChanged: (v) => setState(() => _name = v),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ZiggleButton2(
          onPressed: _name.isEmpty ? null : widget.onNext,
          disabled: _name.isEmpty,
          cta: true,
          child: Text(t.common.next),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
