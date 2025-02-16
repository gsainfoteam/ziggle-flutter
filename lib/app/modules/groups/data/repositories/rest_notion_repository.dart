import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/remote/notion_api.dart';
import 'package:ziggle/app/modules/groups/domain/repository/notion_repository.dart';

@Injectable(as: NotionRepository)
class RestNotionRepository implements NotionRepository {
  final NotionApi _api;

  RestNotionRepository(this._api);

  @override
  Future<Map<String, dynamic>> getNotionPage(String pageId) async {
    try {
      final raw = await _api.getGroups(pageId);

      final Map<String, dynamic> parse = notionParser(raw);

      return parse;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}

Map<String, dynamic> notionParser(String raw) {
  final Map<String, dynamic> originalJson = jsonDecode(raw);

  return originalJson.map((blockId, blockContainer) {
    final blockValue = blockContainer["value"];
    if (blockValue == null) {
      return MapEntry(blockId, null);
    }

    return MapEntry(blockId, {
      "id": blockId,
      "type": blockValue["type"] ?? "",
      "properties": (blockValue["properties"] as Map<String, dynamic>?) ?? {},
      "content": (blockValue["content"] as List?) ?? [],
      "format": (blockValue["format"] as Map<String, dynamic>?) ?? {},
      "parent_id": blockValue["parent_id"],
      "last_edited_time": blockValue["last_edited_time"],
    });
  })
    ..removeWhere((key, value) => value == null);
}
