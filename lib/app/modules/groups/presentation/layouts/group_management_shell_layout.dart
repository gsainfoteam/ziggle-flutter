import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_management_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_member_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_role_bloc.dart';

@RoutePage()
class GroupManagementShellLayout extends StatelessWidget {
  const GroupManagementShellLayout({super.key, required this.group});

  final GroupEntity group;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<GroupManagementBloc>()..add(GroupManagementEvent.load(group)),
        ),
        BlocProvider(
          create: (context) => sl<GroupMemberBloc>()
            ..add(GroupMemberEvent.getMembers(group.uuid)),
        ),
        BlocProvider(
          create: (context) =>
              sl<GroupRoleBloc>()..add(GroupRoleEvent.getRoles(group.uuid)),
        )
      ],
      child: BlocListener<GroupManagementBloc, GroupManagementState>(
        listener: (context, state) {
          state.mapOrNull(error: (error) {
            context.showToast(error.message);
            context.read<GroupManagementBloc>().add(
                  GroupManagementEvent.load(group),
                );
          });
        },
        child: AutoRouter(),
      ),
    );
  }
}
