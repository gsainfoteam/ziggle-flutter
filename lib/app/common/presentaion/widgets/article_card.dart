import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/common/presentaion/widgets/article_tags.dart';
import 'package:ziggle/app/common/presentaion/widgets/button.dart';
import 'package:ziggle/app/common/presentaion/widgets/d_day.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/utils/functions/calculate_date_delta.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/app/core/values/shadows.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_summary_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/gen/strings.g.dart';

const kNoticeCardHeight = 180.0;

class NoticeCard extends StatelessWidget {
  final NoticeSummaryEntity notice;
  final Axis direction;
  final void Function() onTap;
  final bool showType;

  const NoticeCard({
    super.key,
    required this.notice,
    this.direction = Axis.vertical,
    required this.onTap,
    this.showType = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: direction == Axis.horizontal ? kNoticeCardHeight : null,
      child: ZiggleButton(
        onTap: onTap,
        color: Palette.white,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: frameShadows,
        ),
        padding: EdgeInsets.zero,
        child: _buildInner(),
      ),
    );
  }

  Widget _buildInner() {
    final imageUrl = notice.imageUrl;
    if (direction == Axis.horizontal) {
      return Row(
        children: [
          if (imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 140,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: _buildInfo(),
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: _buildInfo(),
        ),
        if (imageUrl != null)
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        if (imageUrl == null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(color: Palette.black, width: 80, height: 1),
                const SizedBox(height: 12),
                Text(
                  notice.body.replaceAll('\n', ' '),
                  style: TextStyles.articleCardBodyStyle,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (notice.currentDeadline != null) ...[
          DDay(
            dDay: calculateDateDelta(
              DateTime.now(),
              notice.currentDeadline!.toLocal(),
            ),
          ),
          const SizedBox(height: 3),
        ],
        Text(
          notice.title,
          style: TextStyles.articleCardTitleStyle,
          maxLines: direction == Axis.horizontal ? 2 : null,
          overflow: direction == Axis.horizontal ? TextOverflow.ellipsis : null,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(notice.author, style: TextStyles.articleCardAuthorStyle),
            const SizedBox(width: 7),
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: '${t.article.views} ',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(text: notice.views.toString()),
              ]),
              style: TextStyles.articleCardAuthorStyle
                  .copyWith(color: Palette.secondaryText),
            ),
          ],
        ),
        if (direction == Axis.horizontal) ...[
          const SizedBox(height: 9),
          NoticeTags(
              tags: showType
                  ? notice.tags.map((e) => e.isType ? e.type : e).toList()
                  : notice.tags.where((t) => !t.isType).toList()),
          const Expanded(child: SizedBox.shrink()),
          Text(
            DateFormat.yMd().format(notice.createdAt),
            style: TextStyles.articleCardAuthorStyle
                .copyWith(color: Palette.secondaryText),
          ),
        ],
      ],
    );
  }
}
