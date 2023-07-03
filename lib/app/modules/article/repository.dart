import 'package:ziggle/app/data/model/article_response.dart';
import 'package:ziggle/app/data/provider/api.dart';

class ArticleRepository {
  final ApiProvider _provider;

  ArticleRepository(this._provider);

  Future<ArticleResponse> getArticleById(int id) => _provider.getNotice(id);
}
