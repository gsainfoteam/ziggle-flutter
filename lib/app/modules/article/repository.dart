import 'package:get/get.dart';
import 'package:ziggle/app/data/model/article_response.dart';

class ArticleRepository {
  Future<ArticleResponse> getArticleById(int id) => Future.delayed(
        1.seconds,
        () => ArticleResponse.sample(8),
      );
}
