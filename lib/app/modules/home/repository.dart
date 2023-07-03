import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/data/provider/api.dart';

class HomeRepository {
  final ApiProvider _provider;

  HomeRepository(this._provider);

  Future<List<ArticleSummaryResponse>> getArticles() {
    return _provider.getNotices().catchError((_) => <ArticleSummaryResponse>[]);
  }
}
