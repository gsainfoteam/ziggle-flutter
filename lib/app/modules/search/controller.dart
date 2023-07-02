import 'package:get/get.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/modules/search/repository.dart';

class SearchController extends GetxController {
  final query = ''.obs;
  final articles = Rxn<List<ArticleSummaryResponse>>();
  final selectedType = Rxn<ArticleType>();
  final SearchRepository repository;

  SearchController(this.repository);

  @override
  void onInit() {
    super.onInit();
    debounce(
      query,
      (callback) => repository.search(callback).then((v) => articles.value = v),
    );
  }
}
