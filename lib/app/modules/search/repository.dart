import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/data/provider/api.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

class SearchRepository {
  final ApiProvider _provider;

  SearchRepository(this._provider);

  Future<List<ArticleSummaryResponse>> search(
    String query,
    Iterable<NoticeType> types,
  ) async {
    final result = await _provider.getNotices(
      limit: 10,
      search: query,
      tags: types.map((e) => e.name).toList(),
    );
    return result.list;
  }
}
