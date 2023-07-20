import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/modules/article_section/controller.dart';

class ArticleSectionPage extends GetView<ArticleSectionController> {
  const ArticleSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.type.title),
      ),
      body: CustomScrollView(
        slivers: [
          Column(
            children: [
              Text(controller.type.emoji,
                  style: const TextStyle(fontSize: 140)),
              Text(controller.type.title, style: TextStyles.articleTitleStyle),
              Text(
                controller.type.description,
                textAlign: TextAlign.center,
                style: TextStyles.articleCardAuthorStyle,
              ),
              const SizedBox(height: 50),
            ],
          ).sliverBox,
        ],
      ),
    );
  }
}
