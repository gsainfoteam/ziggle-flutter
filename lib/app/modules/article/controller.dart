import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/data/model/article_response.dart';
import 'package:ziggle/app/modules/article/repository.dart';
import 'package:ziggle/app/routes/pages.dart';

class ArticleController extends GetxController {
  final article = Rxn<ArticleResponse>();
  final isReminder = false.obs;
  final scrollController = DraggableScrollableController();
  final scrollPixel = 0.0.obs;
  final pageController = PageController();
  final page = 1.obs;
  final maxPage = 8;
  final ArticleRepository repository;

  ArticleController(this.repository);

  @override
  void onInit() {
    super.onInit();
    _load();
    scrollController.addListener(
      () => scrollPixel.value = scrollController.pixels,
    );
    pageController.addListener(() {
      page.value = (pageController.page?.toInt() ?? 0) + 1;
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    pageController.dispose();
    super.onClose();
  }

  Future<void> _load() async {
    final id = Get.parameters['id'];
    if (id == null) return;
    final intId = int.tryParse(id);
    if (intId == null) return;
    article.value = await repository.getArticleById(intId);
  }

  void onPageChanged(int page) {
    pageController.animateToPage(
      page - 1,
      duration: 300.milliseconds,
      curve: Curves.easeOut,
    );
  }

  onImageTap(int index) async {
    final result = await Get.toNamed(
      Routes.ARTICLE_IMAGE,
      arguments: {
        'page': index + 1,
        'images': article.value?.imagesUrl ?? [],
      },
    );
    if (result == null) return;
    pageController.jumpToPage(result - 1);
  }
}
