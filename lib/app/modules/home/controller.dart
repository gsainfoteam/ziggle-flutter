import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/modules/home/repository.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

class HomeController extends GetxController {
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final HomeRepository _repository;

  final articles =
      Map<NoticeType, Rxn<List<ArticleSummaryResponse>>>.fromIterable(
    NoticeType.main,
    value: (_) => Rxn<List<ArticleSummaryResponse>>(),
  );

  HomeController(this._repository);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshIndicatorKey.currentState?.show();
    });
  }

  Future<void> reload() async {
    await Future.wait(NoticeType.main.map(
        (e) => _repository.getArticles(e).then((v) => articles[e]!.value = v)));
  }

  goToList(NoticeType type) {}

  goToDetail(int id) {}
}
