import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/modules/search/repository.dart';

class SearchController extends GetxController {
  final query = ''.obs;
  final articles = Rxn<List<ArticleSummaryResponse>>();
  final selectedType = Rxn<ArticleType>();
  final SearchRepository _repository;
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  SearchController(this._repository);

  @override
  void onInit() {
    super.onInit();
    debounce(query, (callback) {
      if (callback.isEmpty) {
        articles.value = null;
        return;
      }
      articles.value ??= [];
      refreshIndicatorKey.currentState?.show();
    });
  }

  Future<void> search() async {
    final result = await _repository.search(query.value);
    articles.value = result;
  }
}
