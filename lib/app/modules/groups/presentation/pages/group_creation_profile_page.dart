import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/groups/presentation/layouts/group_creation_layout.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupCreationProfilePage extends StatelessWidget {
  const GroupCreationProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GroupCreationLayout(
      step: GroupCreationStep.profile,
      child: _Layout(),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  File? _image;
  String _name = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        if (_image != null)
          SizedBox(
            width: 300,
            height: 300,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(150)),
              child: Image.file(
                _image!,
                fit: BoxFit.cover,
              ),
            ),
          )
        else
          Assets.images.groupDefaultProfile.image(width: 300),
        const SizedBox(height: 27),
        IntrinsicWidth(
          child: ZiggleButton.cta(
            emphasize: false,
            onPressed: () async {
              final image =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (image == null) return;
              setState(() => _image = File(image.path));
            },
            child: Text(context.t.group.creation.setProfileImage),
          ),
        ),
        const SizedBox(height: 60),
        ZiggleInput(
          onChanged: (v) => setState(() => _name = v),
          hintText: context.t.group.creation.profile.name.hint,
          label: Text(context.t.group.creation.profile.name.label),
        ),
        const SizedBox(height: 60),
        ZiggleButton.cta(
          onPressed: () {
            if (_name.isEmpty) return;
            const GroupCreationIntroduceRoute().push(context);
          },
          disabled: _name.isEmpty,
          child: Text(context.t.common.next),
        ),
      ],
    );
  }
}
