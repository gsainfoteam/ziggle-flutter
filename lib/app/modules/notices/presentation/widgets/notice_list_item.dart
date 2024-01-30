import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_content_entity.dart';
import '../../domain/entities/notice_entity.dart';
import '../../presentation/widgets/created_at.dart';

class NoticeListItem extends StatelessWidget {
  const NoticeListItem({
    super.key,
    required this.notice,
    this.onTapDetail,
  });

  final NoticeEntity notice;
  final VoidCallback? onTapDetail;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapDetail,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12) +
            const EdgeInsets.only(left: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notice.contents.main.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            ExtendedText(
              notice.contents.main.body,
              maxLines: 2,
              overflowWidget: TextOverflowWidget(
                child: Text.rich(
                  t.notice.viewMore(
                    more: (more) => TextSpan(
                      text: more,
                      style: const TextStyle(color: Palette.textGrey),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Assets.icons.fireFlame.svg(height: 24),
                const SizedBox(width: 4),
                const Text('67', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 5),
                const Text(
                  '·',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Palette.textGreyDark,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  notice.author,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 5),
                const Text(
                  '·',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Palette.textGreyDark,
                  ),
                ),
                const SizedBox(width: 5),
                CreatedAt(createdAt: notice.createdAt),
              ],
            )
          ],
        ),
      ),
    );
  }
}
