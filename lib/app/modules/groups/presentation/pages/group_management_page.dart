import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/confirm.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_row_button.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_management_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_role_bloc.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupManagementPage extends StatelessWidget {
  const GroupManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        from: PageSource.groupManagementMain,
        backLabel: context.t.group.manage.back,
        title: Text(context.t.group.manage.header),
      ),
      body: BlocConsumer<GroupManagementBloc, GroupManagementState>(
        listener: (context, state) {
          state.whenOrNull(error: (error) => context.showToast(error));
        },
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => Container(),
            initial: () => Container(),
            loading: () => Center(
              child: Lottie.asset(Assets.lotties.loading,
                  height: MediaQuery.of(context).size.width * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2),
            ),
            success: (group) {
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
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (group.profileImageKey != null)
                            SizedBox(
                              width: 300,
                              height: 300,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(150)),
                                child: Image.network(
                                  group.profileImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Assets.images.groupDefaultProfile
                                          .image(width: 90),
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
                        onPressed: () async {
                          final bloc = context.read<GroupManagementBloc>();
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (image == null) return;
                          bloc.add(GroupManagementEvent.updateProfileImage(
                            group.uuid,
                            File(image.path),
                          ));
                        },
                        emphasize: false,
                        child: Text(
                          context.t.group.manage.profileImage,
                          style: TextStyle(color: Palette.black, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 48),
                      BlocBuilder<GroupRoleBloc, GroupRoleState>(
                        builder: (context, state) {
                          final enabled = state.maybeWhen(
                            loaded: (role) => role.isAdmin(),
                            orElse: () => false,
                          );
                          return ZiggleRowButton(
                            showChevron: true,
                            disabled: !enabled,
                            trailingIcon:
                                enabled ? null : Assets.icons.lock.svg(),
                            title: Text(context.t.group.manage.name.header),
                            onPressed: () => GroupManagementNameRoute(
                              uuid: group.uuid,
                              name: group.name,
                            ).push(context),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<GroupRoleBloc, GroupRoleState>(
                        builder: (context, state) {
                          final enabled = state.maybeWhen(
                            loaded: (role) => role.isAdmin(),
                            orElse: () => false,
                          );
                          return ZiggleRowButton(
                            showChevron: true,
                            disabled: !enabled,
                            trailingIcon:
                                enabled ? null : Assets.icons.lock.svg(),
                            title:
                                Text(context.t.group.manage.description.header),
                            onPressed: () => GroupManagementDescriptionRoute(
                              uuid: group.uuid,
                              description: group.description,
                            ).push(context),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<GroupRoleBloc, GroupRoleState>(
                        builder: (context, state) {
                          final enabled = state.maybeWhen(
                            loaded: (role) => role.isAdmin(),
                            orElse: () => false,
                          );
                          return ZiggleRowButton(
                            showChevron: true,
                            disabled: !enabled,
                            trailingIcon:
                                enabled ? null : Assets.icons.lock.svg(),
                            title:
                                Text(context.t.group.manage.notionLink.header),
                            onPressed: () => GroupManagementNotionRoute(
                              uuid: group.uuid,
                              notionLink: group.notionPageId,
                            ).push(context),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<GroupRoleBloc, GroupRoleState>(
                        builder: (context, state) {
                          final enabled = state.maybeWhen(
                            loaded: (role) =>
                                role.isAdmin() || role.isManager(),
                            orElse: () => false,
                          );
                          return ZiggleRowButton(
                            showChevron: true,
                            disabled: !enabled,
                            trailingIcon:
                                enabled ? null : Assets.icons.lock.svg(),
                            title: Text(context.t.group.manage.invite.header),
                            onPressed: () =>
                                GroupManagementInvitationLinkRoute(group: group)
                                    .push(context),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<GroupRoleBloc, GroupRoleState>(
                        builder: (context, state) {
                          final enabled = state.maybeWhen(
                            loaded: (role) => role.isAdmin(),
                            orElse: () => false,
                          );
                          return ZiggleRowButton(
                            showChevron: true,
                            disabled: !enabled,
                            trailingIcon:
                                enabled ? null : Assets.icons.lock.svg(),
                            title: Text(context.t.group.manage.member.header),
                            onPressed: () =>
                                GroupManagementMemberRoute(uuid: group.uuid)
                                    .push(context),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      BlocBuilder<GroupRoleBloc, GroupRoleState>(
                        builder: (context, state) {
                          final enabled = state.maybeWhen(
                            loaded: (role) => role.isAdmin(),
                            orElse: () => false,
                          );
                          return ZiggleRowButton(
                            destructive: true,
                            showChevron: false,
                            disabled: !enabled,
                            trailingIcon:
                                enabled ? null : Assets.icons.lock.svg(),
                            title: Text(context.t.group.manage.delete),
                            onPressed: () async {
                              await context.showDialog<bool>(
                                title: context
                                    .t.group.manage.deleteConfirmationTitle,
                                content: context
                                    .t.group.manage.deleteConfirmationMessage,
                                onConfirm: (dialogContext) {
                                  context.read<GroupManagementBloc>().add(
                                        GroupManagementEvent.delete(group.uuid),
                                      );
                                  context.router
                                      .navigate(GroupManagementMainRoute());
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
                          context.t.group.manage.leave.name,
                          style: TextStyle(
                            color: Palette.primary,
                          ),
                        ),
                        onPressed: () async {
                          await context.showDialog<bool>(
                            title:
                                context.t.group.manage.leaveConfirmationTitle,
                            content:
                                context.t.group.manage.leaveConfirmationMessage,
                            onConfirm: (dialogContext) {
                              context.read<GroupManagementBloc>().add(
                                    GroupManagementEvent.leave(group.uuid),
                                  );
                              context.router
                                  .navigate(GroupManagementMainRoute());
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
