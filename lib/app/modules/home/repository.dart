import 'package:get/get.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';

class HomeRepository {
  Future<List<ArticleSummaryResponse>> getArticles() => Future.delayed(
        1.seconds,
        () => List.generate(4, ArticleSummaryResponse.sample),
      );
}
