import 'dart:convert';

/// Notion API에서 받은 raw JSON 문자열을 받아서
/// 1) jsonDecode 수행
/// 2) 각 블록의 주요 필드만 추출하여 Map<String, dynamic> 형태로 재구성
Map<String, dynamic> notionParser(String raw) {
  // 1) JSON 문자열 -> Map (Key: 블록 UUID, Value: 블록 정보)
  final Map<String, dynamic> originalJson = jsonDecode(raw);

  // 2) 가공한 결과를 담을 변수
  final Map<String, dynamic> parsedResult = {};

  // originalJson은 대개 {"블록ID": {"value": {...}}, "role": ... } 형태이므로, 이를 순회
  for (final entry in originalJson.entries) {
    final blockId = entry.key; // 예: "1292632a-e498-43a7-9fb3-..."
    final blockContainer = entry.value; // {"value": {...}, "role": ... }

    // Notion의 블록 정보는 blockContainer["value"] 안에 대부분 들어 있음
    final blockValue = blockContainer["value"];
    if (blockValue == null) {
      // role: "none" 처럼 블록 정보가 없는 경우가 있으므로 건너뜀
      continue;
    }

    // Notion 블록에서 자주 사용하는 필드들 추출
    final String type = blockValue["type"] ?? "";
    final Map<String, dynamic> properties =
        (blockValue["properties"] as Map<String, dynamic>?) ?? {};
    final List<dynamic> content = (blockValue["content"] as List?) ?? [];
    final Map<String, dynamic> format =
        (blockValue["format"] as Map<String, dynamic>?) ?? {};

    // 원하는 구조로 재정의
    // 필요에 따라 더 많은 필드(id, created_time, permissions 등)를 옮길 수도 있음
    parsedResult[blockId] = {
      "id": blockId,
      "type": type,
      "properties": properties,
      "content": content, // 자식 블록들의 id 배열
      "format": format,
      "parent_id": blockValue["parent_id"],
      "last_edited_time": blockValue["last_edited_time"],
      // ...
    };
  }

  return parsedResult;
}
