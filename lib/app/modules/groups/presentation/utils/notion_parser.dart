import 'dart:convert';

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
