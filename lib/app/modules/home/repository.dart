import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/data/provider/api.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

class HomeRepository {
  final ApiProvider _provider;

  HomeRepository(this._provider);

  Future<List<ArticleSummaryResponse>> getArticles(NoticeType type) async {
    final result = await _provider.getNotices(
      limit: type.isHorizontal ? 10 : 4,
      orderBy: type.sort,
      tags: type.isSearchable ? [type.name] : null,
    );
    return result.list;
  }
}
