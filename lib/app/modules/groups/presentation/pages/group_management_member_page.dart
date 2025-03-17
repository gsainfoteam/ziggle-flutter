import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/confirm.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_management_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_member_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/widgets/group_member_card.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupManagementMemberPage extends StatelessWidget {
  const GroupManagementMemberPage({super.key, required this.uuid});

  final String uuid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<GroupMemberBloc>()..add(GroupMemberEvent.getMembers(uuid)),
      child: Scaffold(
        appBar: ZiggleAppBar.compact(
          from: PageSource.groupManagement,
          backLabel: context.t.group.manage.header,
          title: Text(context.t.group.manage.member.header),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          child: BlocBuilder<GroupMemberBloc, GroupMemberState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => Container(),
                loading: () => Center(
                  child: Lottie.asset(Assets.lotties.loading,
                      height: MediaQuery.of(context).size.width * 0.2,
                      width: MediaQuery.of(context).size.width * 0.2),
                ),
                loaded: (members) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) =>
                              GroupMemberCard.editMode(
                            name: members[index].name,
                            email: members[index].email!,
                            role: members[index].role!,
                            onChanged: (e) {
                              context.read<GroupMemberBloc>().add(
                                  GroupMemberEvent.grantRoleToUser(
                                      uuid,
                                      members[index].uuid,
                                      e!,
                                      members[index].role!));
                            },
                            onBanish: () {
                              context.showDialog<bool>(
                                title: context.t.group.memberCard.banishTitle,
                                content: context
                                    .t.group.memberCard.banishDescription,
                                onConfirm: (_) {
                                  context.read<GroupManagementBloc>().add(
                                      GroupManagementEvent.removeMember(
                                          uuid, members[index].uuid));
                                },
                              );
                            },
                          ),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10),
                          itemCount: members.length,
                        ),
                      ),
                      SizedBox(height: 30),
                      ZiggleButton.cta(
                        child: Text(context.t.group.manage.back),
                        onPressed: () => context.maybePop(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
