import 'package:flutter/material.dart';
import 'package:ziggle/app/data/model/article_response.dart';

import '../article/article_body.dart';

class ArticlePreviewSheet extends StatelessWidget {
  final ArticleResponse article;
  const ArticlePreviewSheet({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.8,
      builder: (context, controller) => SingleChildScrollView(
        controller: controller,
        child: ArticleBody(article: article),
      ),
    );
  }
}
