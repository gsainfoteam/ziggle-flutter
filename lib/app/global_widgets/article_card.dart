import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/utils/functions/calculate_date_delta.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/core/values/shadows.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/global_widgets/article_tags.dart';
import 'package:ziggle/app/global_widgets/d_day.dart';

class ArticleCard extends StatelessWidget {
  final ArticleSummaryResponse article;
  final Axis direction;
  const ArticleCard({
    super.key,
    required this.article,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: frameShadows,
      ),
      child: _buildInner(),
    );
  }

  Widget _buildInner() {
    if (direction == Axis.horizontal) {
      return Row(
        children: [
          if (article.imagesUrl != null && article.imagesUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: CachedNetworkImage(
                imageUrl: article.imagesUrl![0],
                width: 140,
                height: 170,
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
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: _buildInfo(),
        ),
        if (article.imagesUrl != null && article.imagesUrl!.isNotEmpty)
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: CachedNetworkImage(
              imageUrl: article.imagesUrl![0],
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (article.deadline != null) ...[
          DDay(dDay: calculateDateDelta(article.createdAt, article.deadline!)),
          const SizedBox(height: 3),
        ],
        Text(
          article.title,
          style: TextStyles.articleCardTitleStyle,
          maxLines: direction == Axis.horizontal ? 2 : null,
          overflow: direction == Axis.horizontal ? TextOverflow.ellipsis : null,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(article.author, style: TextStyles.articleCardAuthorStyle),
            const SizedBox(width: 7),
            Text.rich(
              TextSpan(children: [
                const TextSpan(
                  text: '조회수 ',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(text: article.views.toString()),
              ]),
              style: TextStyles.articleCardAuthorStyle
                  .copyWith(color: Palette.secondaryText),
            ),
          ],
        ),
        if (direction == Axis.horizontal) ...[
          const SizedBox(height: 9),
          ArticleTags(tags: article.tags),
          const Expanded(child: SizedBox.shrink()),
          Text(
            DateFormat.yMd().format(article.createdAt),
            style: TextStyles.articleCardAuthorStyle
                .copyWith(color: Palette.secondaryText),
          ),
        ],
      ],
    );
  }
}
