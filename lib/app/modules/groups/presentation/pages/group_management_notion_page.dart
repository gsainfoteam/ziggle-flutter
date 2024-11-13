import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupManagementNotionPage extends StatelessWidget {
  const GroupManagementNotionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        from: PageSource.groupManagement,
        backLabel: context.t.group.manage.header,
        title: Text('노션 링크 변경'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        child: Column(
          children: [
            ZiggleInput(hintText: '노션 링크 입력'),
            SizedBox(height: 30),
            ZiggleButton.cta(
              child: Text(context.t.group.manage.change),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
