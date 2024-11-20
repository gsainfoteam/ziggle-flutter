import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_select.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupManagementInvitationLinkPage extends StatefulWidget {
  const GroupManagementInvitationLinkPage({super.key});

  @override
  State<GroupManagementInvitationLinkPage> createState() =>
      _GroupManagementInvitationLinkPageState();
}

class _GroupManagementInvitationLinkPageState
    extends State<GroupManagementInvitationLinkPage> {
  int? _duration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        from: PageSource.groupManagement,
        backLabel: context.t.group.manage.header,
        title: Text(context.t.group.manage.invite.header),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          children: [
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Palette.grayLight,
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Assets.icons.link.svg(),
                      const SizedBox(width: 6),
                      Text(context.t.group.manage.invite.invitationLink),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ZiggleSelect(
                    value: _duration,
                    onChanged: (v) => setState(() => _duration = v),
                    hintText: context.t.group.creation.done.invite.selectExpire,
                    entries: [
                      ZiggleSelectEntry(
                        value: 1,
                        label: context.t.common.duration.day(n: 1),
                      ),
                      ZiggleSelectEntry(
                        value: 3,
                        label: context.t.common.duration.day(n: 3),
                      ),
                      ZiggleSelectEntry(
                        value: 7,
                        label: context.t.common.duration.week(n: 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ZiggleButton.cta(
              child: Text(context.t.group.manage.change),
              onPressed: () => context.maybePop(),
            ),
          ],
        ),
      ),
    );
  }
}
