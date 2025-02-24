import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_tab_bar.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_member_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/notion_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/notion_page_builder.dart';
import 'package:ziggle/app/modules/groups/presentation/widgets/group_member_card.dart';
import 'package:ziggle/app/modules/groups/presentation/widgets/sliver_pinned_box_adapter.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_list_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/list_layout.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupDetailPage extends StatelessWidget {
  const GroupDetailPage({super.key, required this.group});

  final GroupEntity group;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: context.t.group.detail.appBar.backLabel,
        title: Text(context.t.group.detail.appBar.title),
        backgroundColor: Palette.white,
        actions: [
          ZiggleButton.text(
            child: Text(
              context.t.group.manage.header,
              style: const TextStyle(
                fontSize: 16,
                color: Palette.primary,
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () {
              GroupManagementShellRoute(group: group).push(context);
            },
          ),
        ],
        from: PageSource.unknown, // TODO
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<NotionBloc>()
              ..add(NotionEvent.load(notionLink: group.notionPageId!)),
          ),
          BlocProvider(
            create: (context) => sl<NoticeListBloc>()
              ..add(NoticeListEvent.load(NoticeType.group, query: group.uuid)),
          ),
          BlocProvider(
              create: (context) => sl<GroupMemberBloc>()
                ..add(GroupMemberEvent.getMembers(group.uuid))),
        ],
        child: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverPinnedBoxAdapter(
                pinned: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          if (group.profileImageKey != null)
                            SizedBox(
                              width: 90,
                              height: 90,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(150)),
                                child: Image.network(group.profileImageUrl!,
                                    fit: BoxFit.cover),
                              ),
                            )
                          else
                            Assets.images.groupDefaultProfile.image(width: 90),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    group.name,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  // SizedBox(width: 5),
                                  // Assets.icons.badgeCheck.svg()
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '게시글 n개',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Palette.grayText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Palette.grayLight,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  group.description,
                                  style: TextStyle(
                                    color: Palette.grayText,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 15),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: ZiggleButton.cta(
                      //         onPressed: () {},
                      //         child: Text(context.t.group.detail.favorite),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              SliverPinnedBoxAdapter(
                pinned: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    color: Palette.white,
                    child: ZiggleTabBar(
                      tabs: [
                        Tab(text: context.t.group.detail.tab.introduction),
                        Tab(text: context.t.group.detail.tab.notice),
                        Tab(text: context.t.group.detail.tab.member),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            body: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 15, 16, 0),
                  child: BlocBuilder<NotionBloc, NotionState>(
                    builder: (context, state) {
                      return state.when(
                        done: (data) => NotionPageBuilder(blocksMap: data),
                        error: (error) => Container(),
                        initial: () => Container(),
                        loading: () => Center(
                          child: Lottie.asset(Assets.lotties.loading,
                              height: MediaQuery.of(context).size.width * 0.2,
                              width: MediaQuery.of(context).size.width * 0.2),
                        ),
                      );
                    },
                  ),
                ),
                BlocListener<NoticeListBloc, NoticeListState>(
                  listener: (context, state) => state.mapOrNull(
                    error: (error) => context.showToast(error.message),
                  ),
                  child: const ListLayout(
                    noticeType: NoticeType.group,
                  ),
                ),
                BlocBuilder<GroupMemberBloc, GroupMemberState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: state.maybeMap(
                        loaded: (value) => SingleChildScrollView(
                          child: Column(
                            children: [
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Assets.icons.userCircle
                                        .svg(width: 24, height: 24),
                                    SizedBox(width: 5),
                                    Text(
                                      '${value.list.list.length}명',
                                      style: TextStyle(
                                        color: Palette.grayText,
                                        fontSize: 18,
                                        fontFamily: 'Pretendard Variable',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: value.list.list.length,
                                itemBuilder: (context, index) {
                                  final member = value.list.list[index];
                                  return GroupMemberCard.viewMode(
                                      name: value.list.list[index].name,
                                      email: value.list.list[index].email,
                                      role: value.list.list[index].role);
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 5),
                              ),
                            ],
                          ),
                        ),
                        orElse: () => Center(
                          child: Lottie.asset(Assets.lotties.loading,
                              height: MediaQuery.of(context).size.width * 0.2,
                              width: MediaQuery.of(context).size.width * 0.2),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
