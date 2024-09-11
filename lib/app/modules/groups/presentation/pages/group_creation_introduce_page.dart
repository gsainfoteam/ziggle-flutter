import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class GroupCreationIntroducePage extends StatefulWidget {
  const GroupCreationIntroducePage({super.key});

  @override
  State<GroupCreationIntroducePage> createState() =>
      _GroupCreationIntroducePageState();
}

class _GroupCreationIntroducePageState
    extends State<GroupCreationIntroducePage> {
  String _content = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          t.group.creation.introduce.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Palette.black,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          t.group.creation.introduce.description,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Palette.grayText,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Assets.icons.editPencil.svg(width: 24),
            const SizedBox(width: 10),
            Text(
              '${_content.length}/200',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Palette.grayText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(height: 1, color: Palette.grayBorder),
        TextFormField(
          minLines: 7,
          maxLines: 10,
          maxLength: 200,
          onChanged: (v) => setState(() => _content = v),
          decoration: InputDecoration(
            counter: const SizedBox.shrink(),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 13),
            hintText: t.group.creation.introduce.hint,
            hintStyle: const TextStyle(color: Palette.grayText),
          ),
        ),
        Container(height: 1, color: Palette.grayBorder),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: ZiggleButton(
                outlined: true,
                onPressed: () => context.pop(),
                child: Text(t.common.back),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ZiggleButton(
                onPressed: () {
                  if (_content.isEmpty) return;
                  const GroupCreationRoute(GroupCreationStep.notion)
                      .push(context);
                },
                disabled: _content.isEmpty,
                child: Text(t.common.next),
              ),
            ),
          ],
        )
      ],
    );
  }
}
