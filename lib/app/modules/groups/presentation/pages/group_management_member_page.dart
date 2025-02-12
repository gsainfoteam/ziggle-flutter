import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/groups/data/enums/group_member_role.dart';
import 'package:ziggle/app/modules/groups/presentation/widgets/group_member_card.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupManagementMemberPage extends StatelessWidget {
  const GroupManagementMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        from: PageSource.groupManagement,
        backLabel: context.t.group.manage.header,
        title: Text(context.t.group.manage.member.header),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        child: Column(
          children: [
            GroupMemberCard.editMode(
              name: 'test',
              email: 'test@naver.com',
              role: GroupMemberRole.admin,
              onBanish: () {},
              onChanged: (e) {},
            ),
            SizedBox(height: 30),
            ZiggleButton.cta(
              child: Text(context.t.group.manage.back),
              onPressed: () => context.maybePop(),
            ),
          ],
        ),
      ),
    );
  }
}
