import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupManagementDescriptionPage extends StatefulWidget {
  const GroupManagementDescriptionPage({super.key});

  @override
  State<GroupManagementDescriptionPage> createState() =>
      _GroupManagementDescriptionPageState();
}

class _GroupManagementDescriptionPageState
    extends State<GroupManagementDescriptionPage> {
  String _content = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        from: PageSource.groupManagement,
        backLabel: context.t.group.manage.header,
        title: Text(context.t.group.manage.description.header),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        child: Column(
          children: [
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
                hintText: context.t.group.creation.introduce.hint,
                hintStyle: const TextStyle(color: Palette.grayText),
              ),
            ),
            Container(height: 1, color: Palette.grayBorder),
            SizedBox(height: 30),
            ZiggleButton.cta(child: Text(context.t.group.manage.change))
          ],
        ),
      ),
    );
  }
}
