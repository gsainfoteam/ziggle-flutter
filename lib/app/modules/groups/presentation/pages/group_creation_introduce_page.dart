import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_create_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/layouts/group_creation_layout.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupCreationIntroducePage extends StatelessWidget {
  const GroupCreationIntroducePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GroupCreationLayout(
      step: GroupCreationStep.introduce,
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
        Text(
          context.t.group.creation.introduce.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Palette.black,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          context.t.group.creation.introduce.description,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Palette.grayText,
          ),
        ),
        const SizedBox(height: 30),
        BlocBuilder<GroupCreateBloc, GroupCreateState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Assets.icons.editPencil.svg(width: 24),
                const SizedBox(width: 10),
                Text(
                  '${state.draft.description.length}/200',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Palette.grayText,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        Container(height: 1, color: Palette.grayBorder),
        BlocBuilder<GroupCreateBloc, GroupCreateState>(
          builder: (context, state) {
            return TextFormField(
              minLines: 7,
              maxLines: 10,
              maxLength: 200,
              initialValue: state.draft.description,
              onChanged: (v) => context
                  .read<GroupCreateBloc>()
                  .add(GroupCreateEvent.setDescription(v)),
              decoration: InputDecoration(
                counter: const SizedBox.shrink(),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
                hintText: context.t.group.creation.introduce.hint,
                hintStyle: const TextStyle(color: Palette.grayText),
              ),
            );
          },
        ),
        Container(height: 1, color: Palette.grayBorder),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: ZiggleButton.cta(
                outlined: true,
                onPressed: () => context.router.maybePop(),
                child: Text(context.t.common.back),
              ),
            ),
            const SizedBox(width: 10),
            BlocBuilder<GroupCreateBloc, GroupCreateState>(
              builder: (context, state) {
                return Expanded(
                  child: ZiggleButton.cta(
                    onPressed: () {
                      const GroupCreationNotionRoute().push(context);
                    },
                    disabled: state.isDescriptionEmpty,
                    child: Text(context.t.common.next),
                  ),
                );
              },
            ),
          ],
        )
      ],
    );
  }
}
