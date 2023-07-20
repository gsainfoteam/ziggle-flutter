import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/modules/search/repository.dart';

class SearchController extends GetxController {
  final query = ''.obs;
  final articles = Rxn<List<ArticleSummaryResponse>>();
  final selectedType = <ArticleType>{}.obs;
  final SearchRepository _repository;
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  SearchController(this._repository);

  @override
  void onInit() {
    super.onInit();
    debounce(query, _debounceHandler);
    ever(selectedType, _debounceHandler);
  }

  _debounceHandler(callback) {
    if (query.value.isEmpty) {
      articles.value = null;
      return;
    }
    articles.value ??= [];
    refreshIndicatorKey.currentState?.show();
  }

  Future<void> search() async {
    final result = await _repository.search(query.value, selectedType);
    articles.value = result;
  }

  toggleType(ArticleType type) {
    if (selectedType.contains(type)) {
      selectedType.remove(type);
    } else {
      selectedType.add(type);
    }
  }
}
