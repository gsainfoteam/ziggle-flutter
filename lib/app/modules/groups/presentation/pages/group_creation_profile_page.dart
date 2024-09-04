import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_button_2.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/groups/presentation/enums/group_creation_stage.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class GroupCreationProfilePage extends StatefulWidget {
  const GroupCreationProfilePage({super.key});

  @override
  State<GroupCreationProfilePage> createState() =>
      _GroupCreationProfilePageState();
}

class _GroupCreationProfilePageState extends State<GroupCreationProfilePage> {
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
          onPressed: _name.isEmpty
              ? null
              : () => const GroupCreationRoute(GroupCreationStage.introduce)
                  .push(context),
          disabled: _name.isEmpty,
          cta: true,
          child: Text(t.common.next),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
