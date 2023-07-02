import 'package:get/get.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';

class SearchRepository {
  Future<List<ArticleSummaryResponse>> search(String query) => Future.delayed(
        1.seconds,
        () => List.generate(20, ArticleSummaryResponse.sample),
      );
}
