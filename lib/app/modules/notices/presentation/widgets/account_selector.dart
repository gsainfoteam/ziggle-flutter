import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/widgets/group_list_item.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_group_entity.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:ziggle/gen/assets.gen.dart';

class AccountSelector extends StatefulWidget {
  const AccountSelector({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<NoticeGroupEntity?> onChanged;

  @override
  State<AccountSelector> createState() => _AccountSelectorState();
}

class _AccountSelectorState extends State<AccountSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<GroupBloc, GroupState>(
          builder: (context, groupState) {
            if (groupState.isLoading) {
              return Lottie.asset(Assets.lotties.loading,
                  width: 30, height: 30);
            }
            final groupList = groupState.groups;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: groupList == null
                  ? GroupListItem(
                      name: UserBloc.userOrNull(context)!.name,
                      profileImage:
                          Assets.images.defaultProfile.image(width: 36),
                      onPressed: () {
                        widget.onChanged(null);
                      },
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: groupList.list.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return GroupListItem(
                            name: UserBloc.userOrNull(context)!.name,
                            profileImage:
                                Assets.images.defaultProfile.image(width: 36),
                            onPressed: () {
                              widget.onChanged(null);
                            },
                          );
                        } else {
                          return GroupListItem(
                            name: groupList.list[index - 1].name,
                            onPressed: () {
                              widget.onChanged(NoticeGroupEntity.fromGroupModel(
                                  groupList.list[index - 1]));
                            },
                          );
                        }
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                    ),
            );
          },
        ),
      ],
    );
  }
}
