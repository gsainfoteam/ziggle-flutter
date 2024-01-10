import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ziggle/app/common/presentaion/widgets/article_tags.dart';
import 'package:ziggle/app/common/presentaion/widgets/button.dart';
import 'package:ziggle/app/common/presentaion/widgets/d_day.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/utils/functions/calculate_date_delta.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeBody extends StatefulWidget {
  final NoticeEntity notice;
  final void Function()? report;
  const NoticeBody({super.key, required this.notice, this.report});

  @override
  State<NoticeBody> createState() => _NoticeBodyState();
}

class _NoticeBodyState extends State<NoticeBody> {
  late WebViewController controller;
  double _webViewHeight = 300.0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000));
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.notice.contents.localed;

    controller
      ..setNavigationDelegate(
          NavigationDelegate(onNavigationRequest: (request) {
        if (request.url.startsWith('http')) {
          _openUrl(request.url);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      }, onPageFinished: (x) async {
        var x = await controller.runJavaScriptReturningResult(
            "document.documentElement.scrollHeight");
        double? y = double.tryParse(x.toString());
        debugPrint('parse : $y');
        setState(() {
          _webViewHeight = y ?? 300;
        });
      }))
      ..loadHtmlString('''<!DOCTYPE html>
      <html style="font-size: 48px">
      <body>
        ${content.body}
      </body>
      </html>
        ''');

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(content.title, style: TextStyles.articleTitleStyle),
            const SizedBox(height: 12),
            if (widget.notice.tags.isNotEmpty) ...[
              NoticeTags(tags: widget.notice.tags, showAll: true),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                _buildTextRich(t.article.author, widget.notice.author),
                const SizedBox(width: 6),
                _buildTextRich(t.article.views, widget.notice.views.toString(),
                    FontWeight.w500),
              ],
            ),
            const SizedBox(height: 10),
            if (widget.notice.currentDeadline != null) ...[
              Row(
                children: [
                  _buildTextRich(
                    t.article.deadline,
                    DateFormat.yMEd()
                        .format(widget.notice.currentDeadline!.toLocal()),
                  ),
                  const SizedBox(width: 10),
                  DDay(
                    dDay: calculateDateDelta(
                      DateTime.now(),
                      widget.notice.currentDeadline!.toLocal(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10)
            ],
            _buildTextRich(t.article.createdAt,
                DateFormat.yMd().format(widget.notice.createdAt)),
            const Divider(
              thickness: 1,
              height: 30,
              color: Palette.placeholder,
            ),
            SelectionArea(
              child: SizedBox(
                height: _webViewHeight,
                child: WebViewWidget(
                  controller: controller,
                ),
              ),
              // Html(
              //   data: content.body,
              //   style: {'body': Style(margin: Margins.zero)},
              //   onLinkTap: (url, _, __) => _openUrl(url),
              // ),
            ),
            for (final additional
                in widget.notice.contents.localeds.additionals) ...[
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
            if (widget.report != null) ...[
              const Divider(
                thickness: 1,
                height: 30,
                color: Palette.placeholder,
              ),
              ZiggleButton(
                text: t.article.report.action,
                textStyle: TextStyles.link,
                color: Colors.transparent,
                onTap: widget.report,
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
