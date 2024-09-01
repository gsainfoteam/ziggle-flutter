import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_button_2.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class GroupDetailPage extends StatelessWidget {
  const GroupDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.background100,
        leadingWidth: Theme.of(context).appBarTheme.toolbarHeight,
        title: Text(t.group.detail.title),
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
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
                        color: Palette.primary100,
                        fontWeight: FontWeight.w500,
                      ),
                      indicator: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Palette.primary100,
                            width: 3,
                          ),
                        ),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Palette.text400,
                      dividerHeight: 3,
                      tabs: <Tab>[
                        Tab(text: t.group.detail.introduction),
                        Tab(text: t.group.detail.notice),
                        Tab(text: t.group.detail.member),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Item $index'),
                    );
                  },
                ),
                const SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
    return Container(
      color: Palette.background100,
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
                          color: Palette.text300,
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
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF7F7F7),
            ),
            child: const Column(
              children: [
                Text(
                  '지속 가능한 개발 문화를 통해 지스트 학부생의 삶의 질을 높이는 팀, 인포팀입니다.',
                  style: TextStyle(
                    color: Palette.text300,
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
                child: ZiggleButton2(
                  onPressed: () {},
                  cta: true,
                  child: Text(t.group.detail.subscribe),
                ),
              ),
            ],
          ),
        ],
      ),
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
