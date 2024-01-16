import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/sliver_pinned_header.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({super.key, required this.notice});

  final NoticeEntity notice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(t.notice.title),
            pinned: true,
          ),
          if (notice.currentDeadline != null)
            SliverPinnedHeader(
              child: Container(
                color: Palette.primary100,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: DefaultTextStyle.merge(
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Palette.background100,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t.notice.deadline),
                      Text(
                        DateFormat.yMd()
                            .add_Hm()
                            .format(notice.currentDeadline!),
                      )
                    ],
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(notice.contents.first['body']),
              ),
            ),
          )
        ],
      ),
    );
  }
}
