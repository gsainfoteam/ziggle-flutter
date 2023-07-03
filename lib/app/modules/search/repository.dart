import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/data/provider/api.dart';

class SearchRepository {
  final ApiProvider _provider;

  SearchRepository(this._provider);

  Future<List<ArticleSummaryResponse>> search(String query) {
    return _provider.getNotices().catchError((_) => <ArticleSummaryResponse>[]);
  }
}
