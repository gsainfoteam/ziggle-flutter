import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/data/provider/api.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_my.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

class ArticleSectionRepository {
  final ApiProvider _provider;

  ArticleSectionRepository(this._provider);

  Future<List<ArticleSummaryResponse>> getArticles(
    NoticeType type,
    int page,
  ) async {
    const limit = 10;
    final result = await _provider.getNotices(
      limit: limit,
      offset: (page - 1) * limit,
      tags: type.isSearchable ? [type.name] : null,
      orderBy: type.sort,
      my: type.my,
    );
    return result.list;
  }
}
