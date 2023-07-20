import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/modules/home/repository.dart';

class HomeController extends GetxController {
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final HomeRepository _repository;
  final deadlineArticles = Rxn<List<ArticleSummaryResponse>>();
  final hotArticles = Rxn<List<ArticleSummaryResponse>>();
  final eventArticles = Rxn<List<ArticleSummaryResponse>>();
  final recruitArticles = Rxn<List<ArticleSummaryResponse>>();
  final generalArticles = Rxn<List<ArticleSummaryResponse>>();
  final academicArticles = Rxn<List<ArticleSummaryResponse>>();

  HomeController(this._repository);

  @override
  void onInit() {
    super.onInit();
    Future.microtask(() => refreshIndicatorKey.currentState?.show());
  }

  Future<void> reload() async {
    await Future.wait([
      _repository
          .getArticles(ArticleType.deadline)
          .then((v) => deadlineArticles.value = v),
      _repository
          .getArticles(ArticleType.hot)
          .then((v) => hotArticles.value = v),
      _repository
          .getArticles(ArticleType.event)
          .then((v) => eventArticles.value = v),
      _repository
          .getArticles(ArticleType.recruit)
          .then((v) => recruitArticles.value = v),
      _repository
          .getArticles(ArticleType.general)
          .then((v) => generalArticles.value = v),
      _repository
          .getArticles(ArticleType.academic)
          .then((v) => academicArticles.value = v),
    ]);
  }

  goToList(ArticleType type) {}
}
