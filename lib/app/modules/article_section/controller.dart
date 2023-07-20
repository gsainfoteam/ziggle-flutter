import 'package:get/get.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/modules/article_section/repository.dart';
import 'package:ziggle/app/routes/pages.dart';

class ArticleSectionController extends GetxController {
  final type = ArticleType.values.byName(Get.parameters['type']!);
  final articles = Rxn<List<ArticleSummaryResponse>>();
  final ArticleSectionRepository _repository;

  ArticleSectionController(this._repository);

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  _load() {
    _repository.getArticles(type, 1).then((value) => articles.value = value);
  }

  goToDetail(int id) {
    Get.toNamed(Routes.ARTICLE, parameters: {'id': id.toString()});
  }
}
