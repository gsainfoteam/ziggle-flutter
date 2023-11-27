import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziggle/app/common/presentaion/widgets/article_tags.dart';
import 'package:ziggle/app/common/presentaion/widgets/button.dart';
import 'package:ziggle/app/common/presentaion/widgets/d_day.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/utils/functions/calculate_date_delta.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeBody extends StatelessWidget {
  final NoticeEntity notice;
  final void Function()? report;
  const NoticeBody({super.key, required this.notice, this.report});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(notice.title, style: TextStyles.articleTitleStyle),
            const SizedBox(height: 12),
            if (notice.tags.isNotEmpty) ...[
              NoticeTags(tags: notice.tags, showAll: true),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                _buildTextRich(t.article.author, notice.author),
                const SizedBox(width: 6),
                _buildTextRich(
                    t.article.views, notice.views.toString(), FontWeight.w500),
              ],
            ),
            const SizedBox(height: 10),
            if (notice.currentDeadline != null) ...[
              Row(
                children: [
                  _buildTextRich(
                    t.article.deadline,
                    DateFormat.yMEd().format(notice.currentDeadline!.toLocal()),
                  ),
                  const SizedBox(width: 10),
                  DDay(
                    dDay: calculateDateDelta(
                      DateTime.now(),
                      notice.currentDeadline!.toLocal(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10)
            ],
            _buildTextRich(
                t.article.createdAt, DateFormat.yMd().format(notice.createdAt)),
            const Divider(
              thickness: 1,
              height: 30,
              color: Palette.placeholder,
            ),
            SelectionArea(
              child: Html(
                data: notice.body,
                style: {'body': Style(margin: Margins.zero)},
                onLinkTap: (url, _, __) => _openUrl(url),
              ),
            ),
            for (final additional in notice.contents.localeds.additionals) ...[
              const Divider(
                thickness: 1,
                height: 30,
                color: Palette.placeholder,
              ),
              SelectionArea(
                child: Html(
                  data: additional.body,
                  style: {'body': Style(margin: Margins.zero)},
                  onLinkTap: (url, _, __) => _openUrl(url),
                ),
              ),
            ],
            if (report != null) ...[
              const Divider(
                thickness: 1,
                height: 30,
                color: Palette.placeholder,
              ),
              ZiggleButton(
                text: t.article.report.action,
                textStyle: TextStyles.link,
                color: Colors.transparent,
                onTap: report,
              ),
            ],
          ],
        ));
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

  _openUrl(String? urlString) async {
    if (urlString == null) return;
    final url = Uri.tryParse(urlString);
    if (url == null) return;
    try {
      final result =
          await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
      if (!result) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
