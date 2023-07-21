import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/data/provider/api.dart';

class SearchRepository {
  final ApiProvider _provider;

  SearchRepository(this._provider);

  Future<List<ArticleSummaryResponse>> search(
    String query,
    Iterable<ArticleType> types,
  ) async {
    final result = await _provider.getNotices(
      limit: 10,
      search: query,
      tags: types.map((e) => e.name).toList(),
    );
    return result.list;
  }
}
