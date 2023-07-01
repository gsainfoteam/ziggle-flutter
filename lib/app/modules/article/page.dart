import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/core/values/shadows.dart';
import 'package:ziggle/app/modules/article/article_body.dart';
import 'package:ziggle/app/modules/article/controller.dart';
import 'package:ziggle/app/modules/article/page_spinner.dart';

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
      body: Obx(_buildInner),
    );
  }

  Widget _buildInner() {
    if (controller.article.value == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final article = controller.article.value!;
    final child = SafeArea(child: ArticleBody(article: article));

    if (article.imagesUrl?.isNotEmpty ?? false) {
      final bottomSheet = DraggableScrollableSheet(
        controller: controller.scrollController,
        initialChildSize: 0.25,
        builder: (context, scrollController) => SingleChildScrollView(
          clipBehavior: Clip.none,
          controller: scrollController,
          child: Container(
            decoration: const BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: frameShadows,
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 68,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Palette.placeholder,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      );
      return Stack(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            controller.scrollPixel.value = constraints.maxHeight * 0.25;
            final minHeight = constraints.maxHeight * 0.25;
            return Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                height: max(
                  constraints.maxHeight - controller.scrollPixel.value,
                  minHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: PageView.builder(
                        clipBehavior: Clip.none,
                        controller: controller.pageController,
                        itemBuilder: (context, index) => Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Palette.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: frameShadows,
                          ),
                          child: Image.network(article.imagesUrl![index],
                              fit: BoxFit.contain),
                        ).paddingSymmetric(horizontal: 50),
                      ),
                    ),
                    const SizedBox(height: 20),
                    PageSpinner(
                      currentPage: controller.page.value,
                      maxPage: controller.maxPage,
                      onPageChanged: controller.onPageChanged,
                    ),
                  ],
                ),
              ),
            );
          }),
          bottomSheet,
        ],
      );
    } else {
      return SingleChildScrollView(child: child);
    }
  }
}
