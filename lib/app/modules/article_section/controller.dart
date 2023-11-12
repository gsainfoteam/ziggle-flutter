import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ziggle/app/core/routes/routes.dart';
import 'package:ziggle/app/core/utils/extension/date_align.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/modules/article_section/repository.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

class ArticleSectionController extends GetxController {
  final type = NoticeType.values.byName(Get.parameters['type']!);
  final articleController =
      PagingController<int, ArticleSummaryResponse>(firstPageKey: 1);
  final groupArticleController =
      PagingController<int, MapEntry<DateTime, List<ArticleSummaryResponse>>>(
          firstPageKey: 1);
  final ArticleSectionRepository _repository;

  ArticleSectionController(this._repository);

  @override
  void onInit() {
    super.onInit();
    articleController.addPageRequestListener((pageKey) {
      _repository.getArticles(type, pageKey).then((value) {
        if (value.isEmpty) return articleController.appendLastPage(value);
        articleController.appendPage(value, pageKey + 1);
      });
    });
    groupArticleController.addPageRequestListener((pageKey) {
      _repository.getArticles(type, pageKey).then((value) {
        if (value.isEmpty) return groupArticleController.appendLastPage([]);
        final articles = groupBy(
          value,
          (article) => article.deadline!.aligned,
        ).entries.toList();
        if ((groupArticleController.itemList?.isEmpty ?? true) ||
            groupArticleController.itemList!.last.key != articles.first.key) {
          return groupArticleController.appendPage(articles, pageKey + 1);
        }
        groupArticleController.itemList!.last.value
            .addAll(articles.first.value);
        groupArticleController.appendPage(
          articles.skip(1).toList(),
          pageKey + 1,
        );
      });
    });
  }

  @override
  void onClose() {
    articleController.dispose();
    super.onClose();
  }

  goToDetail(int id) {
    Get.toNamed(Paths.article, parameters: {'id': id.toString()});
  }
}
