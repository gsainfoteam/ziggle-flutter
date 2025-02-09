import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/remote/notion_api.dart';
import 'package:ziggle/app/modules/groups/domain/repository/notion_repository.dart';

@Injectable(as: NotionRepository)
class RestNotionRepository implements NotionRepository {
  final NotionApi _api;

  RestNotionRepository(this._api);

  @override
  Future<Map<String, dynamic>> getGroups(String pageId) async {
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

  final Map<String, dynamic> parsedResult = {};

  for (final entry in originalJson.entries) {
    final blockId = entry.key;
    final blockContainer = entry.value;

    final blockValue = blockContainer["value"];
    if (blockValue == null) {
      continue;
    }

    final String type = blockValue["type"] ?? "";
    final Map<String, dynamic> properties =
        (blockValue["properties"] as Map<String, dynamic>?) ?? {};
    final List<dynamic> content = (blockValue["content"] as List?) ?? [];
    final Map<String, dynamic> format =
        (blockValue["format"] as Map<String, dynamic>?) ?? {};

    parsedResult[blockId] = {
      "id": blockId,
      "type": type,
      "properties": properties,
      "content": content,
      "format": format,
      "parent_id": blockValue["parent_id"],
      "last_edited_time": blockValue["last_edited_time"],
    };
  }

  return parsedResult;
}
