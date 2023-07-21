import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/modules/home/repository.dart';
import 'package:ziggle/app/routes/pages.dart';

class HomeController extends GetxController {
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final HomeRepository _repository;

  final articles =
      Map<ArticleType, Rxn<List<ArticleSummaryResponse>>>.fromIterable(
    ArticleType.main,
    value: (_) => Rxn<List<ArticleSummaryResponse>>(),
  );

  HomeController(this._repository);

  @override
  void onInit() {
    super.onInit();
    Future.microtask(() => refreshIndicatorKey.currentState?.show());
  }

  Future<void> reload() async {
    await Future.wait(ArticleType.main.map(
        (e) => _repository.getArticles(e).then((v) => articles[e]!.value = v)));
  }

  goToList(ArticleType type) {
    Get.toNamed(Routes.ARTICLE_SECTION, parameters: {'type': type.name});
  }

  goToDetail(int id) {
    Get.toNamed(Routes.ARTICLE, parameters: {'id': id.toString()});
  }
}
