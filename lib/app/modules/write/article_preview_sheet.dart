import 'package:flutter/material.dart';
import 'package:ziggle/app/data/model/article_response.dart';

class ArticlePreviewSheet extends StatelessWidget {
  final ArticleResponse article;
  const ArticlePreviewSheet({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.75,
      builder: (context, controller) => SingleChildScrollView(
        controller: controller,
        // child: ArticleBody(notice: article),
      ),
    );
  }
}
