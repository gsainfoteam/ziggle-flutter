import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupManagementNamePage extends StatelessWidget {
  const GroupManagementNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        from: PageSource.setting,
        backLabel: context.t.group.manage.header,
        title: Text(context.t.group.manage.name.header),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  context.t.group.manage.name.groupName,
                  style: TextStyle(fontSize: 16, color: Palette.black),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ZiggleInput(hintText: context.t.group.manage.name.helpText),
            const SizedBox(height: 30),
            ZiggleButton.cta(
              child: Text(context.t.group.manage.change),
            )
          ],
        ),
      ),
    );
  }
}
