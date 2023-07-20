import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/data/provider/api.dart';

class HomeRepository {
  final ApiProvider _provider;

  HomeRepository(this._provider);

  Future<List<ArticleSummaryResponse>> getArticles(ArticleType type) {
    return _provider.getNotices(
      limit: type.isHorizontal ? 10 : 4,
      orderBy: type.sort,
      tags: type.isSearchable ? [type.name] : null,
    );
  }
}
