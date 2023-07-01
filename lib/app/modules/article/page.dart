import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/modules/article/article_body.dart';
import 'package:ziggle/app/modules/article/controller.dart';

class ArticlePage extends GetView<ArticleController> {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.article.value?.title ?? '')),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: controller.isReminder.toggle,
            icon: Obx(
              () => Icon(
                Icons.notifications_active,
                color: controller.isReminder.value
                    ? Palette.black
                    : Palette.deselected,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.article.value == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: DraggableScrollableSheet(
                  builder: (context, scrollController) => SingleChildScrollView(
                    controller: scrollController,
                    child: ArticleBody(article: controller.article.value!),
                  ),
                ),
              ),
      ),
    );
  }
}
