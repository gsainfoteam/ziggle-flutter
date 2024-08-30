import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class GroupDetailPage extends StatelessWidget {
  const GroupDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Theme.of(context).appBarTheme.toolbarHeight,
        title: Text(t.group.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
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
            Container(
              height: 51,
              decoration: BoxDecoration(
                color: Palette.primary100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      '구독',
                      style: TextStyle(
                        fontSize: 18,
                        color: Palette.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: Palette.primary100,
                        fontWeight: FontWeight.w500,
                      ),
                      indicator: BoxDecoration(
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
                        Tab(text: '소개'),
                        Tab(text: '공지'),
                        Tab(text: '멤버'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Container(child: const Text('소개 내용입니다.')),
                          Container(child: const Text('공지 내용입니다.')),
                          Container(child: const Text('멤버 내용입니다.')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
