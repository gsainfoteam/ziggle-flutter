import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/utils/functions/calculate_date_delta.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_response.dart';
import 'package:ziggle/app/global_widgets/article_tags.dart';
import 'package:ziggle/app/global_widgets/d_day.dart';
import 'package:ziggle/gen/strings.g.dart';

class ArticleBody extends StatelessWidget {
  final ArticleResponse article;
  const ArticleBody({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(article.title, style: TextStyles.articleTitleStyle),
        const SizedBox(height: 12),
        if (article.tags.isNotEmpty) ...[
          ArticleTags(tags: article.tags.where((t) => !t.isType).toList()),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            _buildTextRich(t.article.author, article.author),
            const SizedBox(width: 6),
            _buildTextRich(
                t.article.views, article.views.toString(), FontWeight.w500),
          ],
        ),
        const SizedBox(height: 10),
        if (article.deadline != null) ...[
          Row(
            children: [
              _buildTextRich(
                t.article.deadline,
                DateFormat.yMEd().format(article.deadline!),
              ),
              const SizedBox(width: 10),
              DDay(
                dDay: calculateDateDelta(
                  DateTime.now(),
                  article.deadline!.toLocal(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10)
        ],
        _buildTextRich(
            t.article.createdAt, DateFormat.yMd().format(article.createdAt)),
        const Divider(
          thickness: 1,
          height: 30,
          color: Palette.placeholder,
        ),
        Html(
          data: article.body,
          style: {
            'body': Style(margin: Margins.zero),
          },
          onLinkTap: (url, _, __) => _openUrl(url),
        ),
      ],
    ).paddingSymmetric(horizontal: 30, vertical: 10);
  }

  Widget _buildTextRich(
    String label,
    String value, [
    FontWeight? fontWeight = FontWeight.bold,
  ]) {
    return Text.rich(
      TextSpan(
        text: '$label ',
        children: [
          TextSpan(text: value, style: TextStyle(fontWeight: fontWeight))
        ],
      ),
    );
  }

  _openUrl(String? urlString) {
    if (urlString == null) return;
    final url = Uri.tryParse(urlString);
    if (url == null) return;
    launchUrl(url);
  }
}
