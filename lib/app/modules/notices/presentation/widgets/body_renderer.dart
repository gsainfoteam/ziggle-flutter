import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:url_launcher/url_launcher.dart';

class BodyRenderer extends StatelessWidget {
  final String content;
  const BodyRenderer({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Html(
        data: content,
        style: {'body': Style(margin: Margins.zero)},
        onLinkTap: (url, _, __) => _openUrl(url),
        extensions: const [
          TableHtmlExtension(),
        ],
      ),
    );
  }
}

void _openUrl(String? urlString) async {
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