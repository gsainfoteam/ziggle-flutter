import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_tab_bar.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/notion_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/notion_page_builder.dart';
import 'package:ziggle/app/modules/groups/presentation/widgets/sliver_pinned_box_adapter.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupDetailPage extends StatelessWidget {
  const GroupDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: context.t.group.detail.appBar.backLabel,
        title: Text(context.t.group.detail.appBar.title),
        backgroundColor: Palette.white,
        from: PageSource.unknown, // TODO
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverPinnedBoxAdapter(
                pinned: false,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '인포팀',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.check,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '구독자 n명 · 게시글 n개',
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
                      child: const Column(
                        children: [
                          Text(
                            '지속 가능한 개발 문화를 통해 지스트 학부생의 삶의 질을 높이는 팀, 인포팀입니다.',
                            style: TextStyle(
                              color: Palette.grayText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: ZiggleButton.cta(
                            onPressed: () {},
                            child: Text(context.t.group.detail.favorite),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              SliverPinnedBoxAdapter(
                pinned: true,
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
            ],
            body: TabBarView(
              children: [
                BlocProvider(
                  create: (context) => sl<NotionBloc>(),
                  child: BlocBuilder<NotionBloc, NotionState>(
                    builder: (context, state) {
                      return state.when(
                        done: (data) => NotionPageBuilder(blocksMap: data),
                        error: (error) => Container(),
                        initial: () => Container(),
                        loading: () => Lottie.asset(Assets.lotties.loading),
                      );
                    },
                  ),
                ),
                CustomScrollView(
                  slivers: [
                    SliverList.builder(
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Item $index'),
                        );
                      },
                    ),
                  ],
                ),
                const SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('공지 내용입니다.공지 내용입니다.'),
                      Text('공지 내용입니다.공지 내용입니다.'),
                      Text('공지 내용입니다.공지 내용입니다.'),
                      Text('공지 내용입니다.공지 내용입니다.'),
                      Text('공지 내용입니다.공지 내용입니다.'),
                      Text('공지 내용입니다.공지 내용입니다.'),
                      Text('공지 내용입니다.공지 내용입니다.'),
                      Text('공지 내용입니다.공지 내용입니다.'),
                      Text('공지 내용입니다.공지 내용입니다.'),
                      Text('공지 내용입니다.공지 내용입니다.'),
                      Text('공지 내용입니다.공지 내용입니다.'),
                    ],
                  ),
                ),
                const Text('멤버 내용입니다.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
