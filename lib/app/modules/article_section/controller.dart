import 'package:get/get.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';

class ArticleSectionController extends GetxController {
  final type = ArticleType.values.byName(Get.parameters['type']!);
  final articles = Rxn<List<ArticleSummaryResponse>>();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  _load() {}
}
