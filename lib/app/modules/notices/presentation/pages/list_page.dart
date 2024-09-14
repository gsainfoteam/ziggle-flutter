import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/notice_card.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.grayLight,
      appBar: ZiggleAppBar.compact(
        backLabel: t.notice.list,
        title: Text(title),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        itemBuilder: (context, index) => NoticeCard(
          onLike: () {},
          onPressed: () {},
          onShare: () {},
          notice: NoticeEntity.mock(
            content: '공지 내용',
            title: '공지 제목',
            deadline: DateTime(2024, 9, 14, 0, 48, 20),
            authorName: '홍길동',
            createdAt: DateTime.now(),
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemCount: 1000,
      ),
    );
  }
}
