import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_management_main_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/widgets/group_list_item.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupManagementMainPage extends StatelessWidget {
  const GroupManagementMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<GroupManagementMainBloc>()..add(GroupManagementMainEvent.load()),
      child: BlocBuilder<GroupManagementMainBloc, GroupManagementMainState>(
        builder: (context, state) {
          return Scaffold(
            appBar: ZiggleAppBar.compact(
              backLabel: context.t.user.myInfo,
              from: PageSource.unknown,
              title: Text(context.t.group.managementMain.header),
              actions: [
                ZiggleButton.text(
                  child: Text(
                    context.t.group.managementMain.newGroup,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Palette.primary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onPressed: () => GroupCreationProfileRoute().push(context),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () => GroupManagementMainBloc.refresh(context),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 25, 16, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          context.t.group.managementMain.myGroup,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (state.groups != null)
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            if (index < state.groups!.list.length) {
                              return GroupListItem(
                                name: state.groups!.list[index].name,
                                onPressed: () {},
                              );
                            } else if (index == state.groups!.list.length) {
                              return Column(
                                children: [
                                  InquiryWidget(),
                                  SizedBox(height: 25),
                                ],
                              );
                            }
                            return null;
                          },
                          separatorBuilder: (context, index) {
                            if (index < state.groups!.list.length - 1) {
                              return const SizedBox(height: 5);
                            }
                            return SizedBox(height: 20);
                          },
                          itemCount: state.groups!.list.length + 1,
                        ),
                      )
                    else if (state.isLoading)
                      Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      Column(
                        children: [
                          Assets.images.bonfire.svg(),
                          const SizedBox(height: 20),
                          Text(
                            context.t.group.managementMain.noGroup,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Palette.grayText,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          InquiryWidget(),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class InquiryWidget extends StatelessWidget {
  const InquiryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: ShapeDecoration(
        color: Palette.grayLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              context.t.group.managementMain.contact,
              style: const TextStyle(
                color: Palette.grayText,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
