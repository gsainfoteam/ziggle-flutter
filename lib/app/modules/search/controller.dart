import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/modules/search/repository.dart';
import 'package:ziggle/app/routes/pages.dart';

class SearchController extends GetxController {
  final query = ''.obs;
  final selectedType = <ArticleType>{}.obs;
  final SearchRepository _repository;
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final pagingController =
      PagingController<int, ArticleSummaryResponse>(firstPageKey: 1);
  final toolbarHeight = 0.0.obs;
  final toolbarKey = GlobalKey();

  SearchController(this._repository);

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) async {
      if (query.value.isEmpty) {
        pagingController.appendLastPage([]);
        return;
      }
      final articles = await _repository.search(query.value, selectedType);
      if (articles.isEmpty) {
        pagingController.appendLastPage(articles);
        return;
      }
      pagingController.appendPage(articles, pageKey + 1);
    });
    debounce(query, _debounceHandler);
    ever(selectedType, _debounceHandler);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      toolbarHeight.value =
          (toolbarKey.currentContext!.findRenderObject() as RenderBox)
              .size
              .height;
    });
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  _debounceHandler(callback) {
    refreshIndicatorKey.currentState?.show();
  }

  Future<void> search() async {
    pagingController.refresh();
  }

  toggleType(ArticleType type) {
    if (selectedType.contains(type)) {
      selectedType.remove(type);
    } else {
      selectedType.add(type);
    }
  }

  goToDetail(int id) {
    Get.toNamed(Routes.ARTICLE, parameters: {'id': id.toString()});
  }
}
