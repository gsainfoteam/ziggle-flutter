import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
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
          child: ZiggleButton(
            emphasize: false,
            onPressed: () async {
              final image =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (image == null) return;
              setState(() => _image = File(image.path));
            },
            child: Text(t.group.creation.setProfileImage),
          ),
        ),
        const SizedBox(height: 60),
        ZiggleInput(
          onChanged: (v) => setState(() => _name = v),
          hintText: t.group.creation.profile.name.hint,
          label: Text(t.group.creation.profile.name.label),
        ),
        const SizedBox(height: 60),
        ZiggleButton(
          onPressed: () {
            if (_name.isEmpty) return;
            const GroupCreationRoute(GroupCreationStep.introduce).push(context);
          },
          disabled: _name.isEmpty,
          child: Text(t.common.next),
        ),
      ],
    );
  }
}
