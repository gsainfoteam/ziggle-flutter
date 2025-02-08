import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/remote/notion_api.dart';
import 'package:ziggle/app/modules/groups/domain/repository/notion_repository.dart';
import 'package:ziggle/app/modules/groups/presentation/utils/notion_parser.dart';

@Injectable(as: NotionRepository)
class RestNotionRepository implements NotionRepository {
  final NotionApi _api;

  RestNotionRepository(this._api);

  @override
  Future<Map<String, dynamic>> getGroups(String pageId) async {
    try {
      final raw = await _api.getGroups(pageId);
      final Map<String, dynamic> parse = await notionParser(raw);
      return parse;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
