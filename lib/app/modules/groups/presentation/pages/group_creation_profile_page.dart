import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_create_bloc.dart';
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

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        BlocBuilder<GroupCreateBloc, GroupCreateState>(
          builder: (context, state) {
            return state.isImageEmpty
                ? Assets.images.groupDefaultProfile.image(width: 300)
                : SizedBox(
                    width: 300,
                    height: 300,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(150)),
                      child: Image.file(
                        state.draft.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
          },
        ),
        const SizedBox(height: 27),
        BlocBuilder<GroupCreateBloc, GroupCreateState>(
          builder: (context, state) {
            return IntrinsicWidth(
              child: ZiggleButton.cta(
                emphasize: false,
                onPressed: () async {
                  final image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (image == null) return;
                  if (context.mounted) {
                    context
                        .read<GroupCreateBloc>()
                        .add(GroupCreateEvent.setImage(File(image.path)));
                  }
                },
                child: Text(context.t.group.creation.setProfileImage),
              ),
            );
          },
        ),
        const SizedBox(height: 60),
        BlocBuilder<GroupCreateBloc, GroupCreateState>(
          builder: (context, state) {
            return ZiggleInput(
              onChanged: (v) => context
                  .read<GroupCreateBloc>()
                  .add(GroupCreateEvent.setName(v)),
              hintText: context.t.group.creation.profile.name.hint,
              label: Text(context.t.group.creation.profile.name.label),
            );
          },
        ),
        const SizedBox(height: 60),
        BlocBuilder<GroupCreateBloc, GroupCreateState>(
          builder: (context, state) {
            return ZiggleButton.cta(
              onPressed: () =>
                  const GroupCreationIntroduceRoute().push(context),
              disabled: state.isNameEmpty,
              child: Text(context.t.common.next),
            );
          },
        ),
      ],
    );
  }
}
