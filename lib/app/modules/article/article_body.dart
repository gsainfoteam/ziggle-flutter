import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziggle/app/data/model/article_response.dart';

class ArticleBody extends StatelessWidget {
  final ArticleResponse article;
  const ArticleBody({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: article.body,
      onLinkTap: (url, _, __) => _openUrl(url),
    );
  }

  _openUrl(String? urlString) {
    if (urlString == null) return;
    final url = Uri.tryParse(urlString);
    if (url == null) return;
    launchUrl(url);
  }
}
