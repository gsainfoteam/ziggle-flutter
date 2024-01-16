import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/sliver_pinned_header.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/enums/notice_type.dart';

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
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice.contents.first['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DefaultTextStyle.merge(
                    style: const TextStyle(color: Palette.primary100),
                    child: Wrap(
                      spacing: 4,
                      children: notice.tags
                          .map((e) => e['name'] as String)
                          .map((e) => NoticeType.fromTag(e)?.label ?? e)
                          .map((e) => Text('#$e'))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
