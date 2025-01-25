import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_management_main_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/widgets/group_list_item.dart';

class AccountSelector extends StatefulWidget {
  const AccountSelector({
    super.key,
  });

  @override
  State<AccountSelector> createState() => _AccountSelectorState();
}

class _AccountSelectorState extends State<AccountSelector> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<GroupManagementMainBloc>()..add(GroupManagementMainEvent.load()),
      child: BlocBuilder<GroupManagementMainBloc, GroupManagementMainState>(
        builder: (context, state) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return GroupListItem(
                name: "Test",
                onPressed: () {},
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 12),
          ),
        ),
      ),
    );
  }
}
