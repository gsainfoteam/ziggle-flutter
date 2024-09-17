import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class GroupDetailPage extends StatelessWidget {
  const GroupDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: context.t.group.detail.appBar.backLabel,
        title: Text(context.t.group.detail.appBar.title),
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverPersistentHeader(
                pinned: false,
                floating: true,
                delegate: GroupInfoHeaderDelegate(),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: MyTabBarDelegate(
                  TabBar(
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      color: Palette.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    indicator: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Palette.primary,
                          width: 3,
                        ),
                      ),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Palette.gray,
                    dividerHeight: 3,
                    tabs: <Tab>[
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
                Builder(
                  builder: (context) {
                    return CustomScrollView(
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
                    );
                  },
                ),
                const SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('소개 내용입니다.소개 내용입니다.'),
                      Text('소개 내용입니다.소개 내용입니다.'),
                      Text('소개 내용입니다.소개 내용입니다.'),
                      Text('소개 내용입니다.소개 내용입니다.'),
                      Text('소개 내용입니다.소개 내용입니다.'),
                      Text('소개 내용입니다.소개 내용입니다.'),
                      Text('소개 내용입니다.소개 내용입니다.'),
                      Text('소개 내용입니다.소개 내용입니다.'),
                      Text('소개 내용입니다.소개 내용입니다.'),
                      Text('소개 내용입니다.소개 내용입니다.'),
                      Text('소개 내용입니다.소개 내용입니다.'),
                    ],
                  ),
                ),
                Container(child: const Text('멤버 내용입니다.')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GroupInfoHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 250;

  @override
  double get maxExtent => 250;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
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
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class MyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  MyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
