import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ziggle/app/core/routes/routes.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/data/services/analytics/service.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/search/repository.dart';

class SearchController extends GetxController {
  final query = ''.obs;
  final selectedType = <NoticeType>{}.obs;
  final SearchRepository _repository;
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final pagingController =
      PagingController<int, ArticleSummaryResponse>(firstPageKey: 1);
  final toolbarHeight = 0.0.obs;
  final toolbarKey = GlobalKey();
  final _analyticsService = AnalyticsService.to;

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
    _analyticsService.logSearch(query.value, selectedType);
  }

  toggleType(NoticeType type) {
    if (selectedType.contains(type)) {
      selectedType.remove(type);
    } else {
      selectedType.add(type);
    }
  }

  goToDetail(int id) {
    Get.toNamed(Paths.article, parameters: {'id': id.toString()});
  }
}
