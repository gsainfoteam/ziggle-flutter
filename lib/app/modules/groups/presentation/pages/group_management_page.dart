import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_row_button.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupManagementPage extends StatelessWidget {
  const GroupManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        from: PageSource.groupManagementMain,
        backLabel: context.t.group.managementMain.header,
        title: Text(context.t.group.manage.header),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 25,
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    '그룹 이름',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Palette.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    color: Colors.green,
                  )
                ],
              ),
              const SizedBox(
                height: 27,
              ),
              ZiggleButton.cta(
                emphasize: false,
                child: Text(
                  context.t.group.manage.profileImage,
                  style: TextStyle(
                    color: Palette.black,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              ZiggleRowButton(
                title: Text(context.t.group.manage.name.header),
                onPressed: () => GroupManagementNameRoute().push(context),
              ),
              const SizedBox(height: 20),
              ZiggleRowButton(
                title: Text(context.t.group.manage.description.header),
                onPressed: () =>
                    GroupManagementDescriptionRoute().push(context),
              ),
              const SizedBox(height: 20),
              ZiggleRowButton(
                title: Text(context.t.group.manage.notionLink.header),
                onPressed: () => GroupManagementNotionRoute().push(context),
              ),
              const SizedBox(height: 20),
              ZiggleRowButton(
                title: Text(context.t.group.manage.invite.header),
                onPressed: () =>
                    GroupManagementInvitationLinkRoute().push(context),
              ),
              const SizedBox(height: 20),
              ZiggleRowButton(
                title: Text(context.t.group.manage.member.header),
                onPressed: () => GroupManagementMemberRoute().push(context),
              ),
              const SizedBox(height: 40),
              ZiggleRowButton(
                title: Text(
                  context.t.group.manage.delete,
                  style: TextStyle(
                    color: Palette.primary,
                  ),
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              ZiggleRowButton(
                title: Text(
                  context.t.group.manage.leave,
                  style: TextStyle(
                    color: Palette.primary,
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
