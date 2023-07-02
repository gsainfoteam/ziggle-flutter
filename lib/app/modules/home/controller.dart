import 'package:get/get.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/modules/home/repository.dart';

class HomeController extends GetxController {
  final HomeRepository repository;
  final deadlineArticles = Rxn<List<ArticleSummaryResponse>>();
  final hotArticles = Rxn<List<ArticleSummaryResponse>>();

  HomeController(this.repository);

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  _load() {
    repository.getArticles().then((v) => deadlineArticles.value = v);
    repository.getArticles().then((v) => hotArticles.value = v);
  }
}
