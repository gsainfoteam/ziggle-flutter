import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_row_button.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_management_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_management_main_bloc.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupManagementPage extends StatelessWidget {
  const GroupManagementPage({
    super.key,
    this.group,
  });
  final GroupEntity? group;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        from: PageSource.groupManagementMain,
        backLabel: context.t.group.managementMain.header,
        title: Text(context.t.group.manage.header),
      ),
      body: BlocBuilder<GroupManagementBloc, GroupManagementState>(
        builder: (context, state) {
          return state.when(
            initial: () => Container(),
            loading: () => Center(
              child: Lottie.asset(Assets.lotties.loading,
                  height: MediaQuery.of(context).size.width * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2),
            ),
            loaded: (group) => _buildBody(context, group),
            success: (group) => _buildBody(context, group),
            error: (message) => Text(
              '오류 발생: $message',
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      ),
    );
  }

  SingleChildScrollView _buildBody(BuildContext context, group) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 25,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  group.name,
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
                if (group!.profileImageKey != null)
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(150)),
                      child: Image.network(
                        group!.profileImageUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Assets.images.groupDefaultProfile.image(width: 300),
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
              showChevron: true,
              title: Text(context.t.group.manage.name.header),
              onPressed: () => GroupManagementNameRoute(
                uuid: group.uuid,
                name: group.name,
              ).push(context),
            ),
            const SizedBox(height: 20),
            ZiggleRowButton(
              showChevron: true,
              title: Text(context.t.group.manage.description.header),
              onPressed: () => GroupManagementDescriptionRoute(
                uuid: group!.uuid,
                description: group!.description,
              ).push(context),
            ),
            const SizedBox(height: 20),
            ZiggleRowButton(
              showChevron: true,
              title: Text(context.t.group.manage.notionLink.header),
              onPressed: () => GroupManagementNotionRoute(
                uuid: group!.uuid,
                notionLink: group!.notionPageId,
              ).push(context),
            ),
            const SizedBox(height: 20),
            ZiggleRowButton(
              showChevron: true,
              title: Text(context.t.group.manage.invite.header),
              onPressed: () =>
                  GroupManagementInvitationLinkRoute().push(context),
            ),
            const SizedBox(height: 20),
            ZiggleRowButton(
              showChevron: true,
              title: Text(context.t.group.manage.member.header),
              onPressed: () =>
                  GroupManagementMemberRoute(uuid: group!.uuid).push(context),
            ),
            const SizedBox(height: 40),
            BlocBuilder<GroupManagementBloc, GroupManagementState>(
              builder: (context, state) {
                return ZiggleRowButton(
                  showChevron: false,
                  title: Text(
                    context.t.group.manage.delete,
                    style: TextStyle(
                      color: Palette.primary,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return CupertinoAlertDialog(
                          title: Text(
                              context.t.group.manage.deleteConfirmationTitle),
                          content: Text(
                              context.t.group.manage.deleteConfirmationMessage),
                          actions: [
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              child: Text(context.t.common.confirm),
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                context.read<GroupManagementBloc>().add(
                                      GroupManagementEvent.delete(group!.uuid),
                                    );
                              },
                            ),
                            CupertinoDialogAction(
                                child: Text(
                                  context.t.common.cancel,
                                  style: TextStyle(
                                    color: Palette.grayText,
                                  ),
                                ),
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop()),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            ZiggleRowButton(
                showChevron: false,
                title: Text(
                  context.t.group.manage.leave,
                  style: TextStyle(
                    color: Palette.primary,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return CupertinoAlertDialog(
                        title:
                            Text(context.t.group.manage.leaveConfirmationTitle),
                        content: Text(
                            context.t.group.manage.leaveConfirmationMessage),
                        actions: [
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: Text(context.t.common.confirm),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              context.read<GroupManagementBloc>().add(
                                    GroupManagementEvent.leave(group!.uuid),
                                  );
                            },
                          ),
                          CupertinoDialogAction(
                              child: Text(
                                context.t.common.cancel,
                                style: TextStyle(
                                  color: Palette.grayText,
                                ),
                              ),
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop()),
                        ],
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
