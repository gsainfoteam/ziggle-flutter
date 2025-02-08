import 'package:flutter/material.dart';

class NotionPageBuilder extends StatelessWidget {
  final Map<String, dynamic> blocksMap;
  final String rootBlockId;

  const NotionPageBuilder({
    super.key,
    required this.blocksMap,
    required this.rootBlockId,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: _buildBlock(rootBlockId, 0),
    );
  }

  Widget _buildBlock(String blockId, int indentLevel) {
    final blockData = blocksMap[blockId];
    if (blockData == null) {
      return const SizedBox.shrink();
    }

    final type = blockData['type'] as String? ?? 'unknown';
    final properties = blockData['properties'] as Map<String, dynamic>? ?? {};
    final content = blockData['content'] as List<dynamic>? ?? [];
    final format = blockData['format'] as Map<String, dynamic>? ?? {};

    switch (type) {
      case 'page':
        if (blockId == rootBlockId) {
          return _buildPageBlock(blockId, properties, content, indentLevel);
        } else {
          return _buildSubPageBlock(blockId, properties, content, indentLevel);
        }
      case 'text':
        return _buildTextBlock(properties, indentLevel);
      case 'header':
        return _buildHeaderBlock(properties, indentLevel);
      case 'sub_header':
        return _buildSubHeaderBlock(properties, indentLevel);
      case 'sub_sub_header':
        return _buildSubSubHeaderBlock(properties, indentLevel);
      case 'quote':
        return _buildQuoteBlock(properties, indentLevel);
      case 'callout':
        return _buildCalloutBlock(properties, indentLevel);
      case 'image':
        return _buildImageBlock(properties, format, indentLevel);
      case 'toggle':
        return _buildToggleBlock(properties, content, indentLevel);
      case 'bulleted_list':
        return _buildBulletedListBlock(properties, content, indentLevel);
      case 'numbered_list':
        return _buildNumberedListBlock(properties, content, indentLevel);

      default:
        return Padding(
          padding: EdgeInsets.only(left: indentLevel * 16.0),
          child: Text(
            '(Unsupported type: $type)',
            style: TextStyle(color: Colors.red),
          ),
        );
    }
  }

  // --------------------------------------------------------------------------
  // 1) Page Block
  // --------------------------------------------------------------------------
  Widget _buildPageBlock(
    String blockId,
    Map<String, dynamic> properties,
    List<dynamic> content,
    int indentLevel,
  ) {
    final pageTitle = _extractPlainText(properties['title']);
    final children = content
        .whereType<String>()
        .map((childId) => _buildBlock(childId, indentLevel))
        .toList();

    return Padding(
      padding: EdgeInsets.only(left: indentLevel * 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pageTitle,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSubPageBlock(
    String blockId,
    Map<String, dynamic> properties,
    List<dynamic> content,
    int indentLevel,
  ) {
    final subPageTitle = _extractPlainText(properties['title']);

    return InkWell(
      onTap: () {
        // TODO: navigate to a new page if desired
        debugPrint('Clicked sub-page: $subPageTitle');
      },
      child: Container(
        margin:
            EdgeInsets.only(top: 4.0, bottom: 4.0, left: indentLevel * 16.0),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(Icons.insert_drive_file, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Text(
              subPageTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 2) Text Block (인라인 스타일)
  // --------------------------------------------------------------------------
  Widget _buildTextBlock(Map<String, dynamic> properties, int indentLevel) {
    final titleProperty = properties['title'];
    return Padding(
      padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: indentLevel * 16.0),
      child: buildRichTextWithBaseStyle(
        titleProperty,
        const TextStyle(fontSize: 14, color: Colors.black),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 3) Header / SubSubHeader / Quote / Callout
  // --------------------------------------------------------------------------
  Widget _buildHeaderBlock(Map<String, dynamic> properties, int indentLevel) {
    final titleProperty = properties['title'];
    return Padding(
      padding:
          EdgeInsets.only(top: 16.0, bottom: 8.0, left: indentLevel * 16.0),
      child: buildRichTextWithBaseStyle(
        titleProperty,
        const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildSubHeaderBlock(
      Map<String, dynamic> properties, int indentLevel) {
    final titleProperty = properties['title'];
    return Padding(
      padding:
          EdgeInsets.only(top: 16.0, bottom: 8.0, left: indentLevel * 16.0),
      child: buildRichTextWithBaseStyle(
        titleProperty,
        const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildSubSubHeaderBlock(
      Map<String, dynamic> properties, int indentLevel) {
    final titleProperty = properties['title'];
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 4.0, left: indentLevel * 16.0),
      child: buildRichTextWithBaseStyle(
        titleProperty,
        const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
      ),
    );
  }

  Widget _buildQuoteBlock(Map<String, dynamic> properties, int indentLevel) {
    final titleProperty = properties['title'];
    return Container(
      margin: EdgeInsets.only(top: 4.0, bottom: 4.0, left: indentLevel * 16.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey.shade400, width: 4)),
      ),
      child: buildRichTextWithBaseStyle(
        titleProperty,
        const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
      ),
    );
  }

  Widget _buildCalloutBlock(Map<String, dynamic> properties, int indentLevel) {
    final titleProperty = properties['title'];
    return Container(
      color: Colors.grey.shade200,
      margin: EdgeInsets.only(top: 8.0, bottom: 8.0, left: indentLevel * 16.0),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const Icon(Icons.info_outline),
          const SizedBox(width: 8),
          Expanded(
            child: buildRichTextWithBaseStyle(
              titleProperty,
              const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 4) Image Block
  // --------------------------------------------------------------------------
  Widget _buildImageBlock(
    Map<String, dynamic> properties,
    Map<String, dynamic> format,
    int indentLevel,
  ) {
    String? imageUrl = _extractImageUrl(properties['source']);
    imageUrl ??= format['display_source']?.toString();
    if (imageUrl == null || imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: indentLevel * 16.0),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) =>
            const Text('Failed to load image'),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 5) Toggle Block
  // --------------------------------------------------------------------------
  Widget _buildToggleBlock(
    Map<String, dynamic> properties,
    List<dynamic> content,
    int indentLevel,
  ) {
    final titleProperty = properties['title'];

    // 자식 블록들
    final childWidgets = content.map<Widget>((childId) {
      if (childId is String) {
        // 토글 안에 또 리스트나 토글이 들어갈 수도 -> indentLevel + 1
        return _buildBlock(childId, indentLevel + 1);
      }
      return const SizedBox.shrink();
    }).toList();

    return Padding(
      padding: EdgeInsets.only(left: indentLevel * 16.0),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.zero,
        ),
        expandedAlignment: Alignment.centerLeft,
        title: buildRichTextWithBaseStyle(
          titleProperty,
          const TextStyle(fontSize: 14, color: Colors.black),
        ),
        collapsedIconColor: Colors.black,
        iconColor: Colors.black,
        children: childWidgets,
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 6) Bulleted List Block
  // --------------------------------------------------------------------------
  Widget _buildBulletedListBlock(
    Map<String, dynamic> properties,
    List<dynamic> content,
    int indentLevel,
  ) {
    final children = <Widget>[];

    // (1) 우선, **이 블록 자체**의 title을 하나의 불릿 아이템으로 표시
    // ex: "안녕"
    final titleProperty = properties['title'];
    if (titleProperty != null) {
      children.add(_buildSingleBulletItem(titleProperty, indentLevel));
    }

    // (2) 그리고, content에 다른 블록이 있으면 재귀적으로 표시
    for (var childId in content) {
      if (childId is String) {
        final childBlock = blocksMap[childId];
        if (childBlock != null) {
          // 재귀적으로 빌드 (만약 child가 'text'면 그건 '•'로 표시할 수도 있고,
          // 또 다른 bulleted_list면 중첩 리스트로 표시)
          children.add(_buildBlock(childId, indentLevel + 1));
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildSingleBulletItem(dynamic titleProperty, int indentLevel) {
    return Padding(
      padding: EdgeInsets.only(top: 2, bottom: 2, left: indentLevel * 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(
            child: buildRichTextWithBaseStyle(
              titleProperty,
              const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 7) Numbered List Block
  // --------------------------------------------------------------------------
  Widget _buildNumberedListBlock(
    Map<String, dynamic> properties,
    List<dynamic> content,
    int indentLevel,
  ) {
    final children = <Widget>[];
    int index = 1; // 번호 시작

    // (1) 블록 자체의 title을 첫 항목으로
    final titleProperty = properties['title'];
    if (titleProperty != null) {
      children.add(_buildNumberedItemTitle(titleProperty, indentLevel));
    }

    // (2) content 순회
    for (var childId in content) {
      if (childId is String) {
        final childBlock = blocksMap[childId];
        if (childBlock != null) {
          // 만약 'text' 블록이면 -> 번호를 붙여 표시
          final childType = childBlock['type'] as String? ?? 'unknown';
          if (childType == 'text') {
            children.add(
                _buildNumberedItemBlock(childBlock, index, indentLevel + 1));
            index++;
          } else {
            // 그 외 블록 -> 재귀
            children.add(_buildBlock(childId, indentLevel + 1));
          }
        }
      }
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  /// numbered_list 블록이 스스로 가진 title -> "1) "(임시) 로 표시
  /// 실제로는 "1. " 뒤에 index++가 필요할 수도 있지만
  /// 여기서는 첫 항목용으로 간단히..
  Widget _buildNumberedItemTitle(dynamic titleProperty, int indentLevel) {
    return Padding(
      padding: EdgeInsets.only(top: 2, bottom: 2, left: indentLevel * 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('1. '),
          Expanded(
            child: buildRichTextWithBaseStyle(
              titleProperty,
              const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  /// numbered_list content 중 "text" 블록을 번호 + 텍스트로 표시
  Widget _buildNumberedItemBlock(
    Map<String, dynamic> blockData,
    int index,
    int indentLevel,
  ) {
    final props = blockData['properties'] as Map<String, dynamic>? ?? {};
    final titleProperty = props['title'];

    return Padding(
      padding: EdgeInsets.only(top: 2, bottom: 2, left: indentLevel * 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$index. '),
          Expanded(
            child: buildRichTextWithBaseStyle(
              titleProperty,
              const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 8) 헬퍼 함수들
  // --------------------------------------------------------------------------
  Widget buildRichTextWithBaseStyle(
      dynamic titleProperty, TextStyle baseStyle) {
    if (titleProperty is! List) {
      return const Text('');
    }
    final spans = <InlineSpan>[];

    for (final piece in titleProperty) {
      if (piece is List && piece.isNotEmpty) {
        final textSegment = piece[0] is String ? piece[0] as String : '';
        final styleDirectives = (piece.length > 1) ? piece[1] : null;
        final inlineStyle = _parseNotionStyle(styleDirectives);
        final mergedStyle = baseStyle.merge(inlineStyle);
        spans.add(TextSpan(text: textSegment, style: mergedStyle));
      }
    }

    if (spans.isEmpty) {
      return const Text('');
    }

    return RichText(
      text: TextSpan(children: spans, style: baseStyle),
    );
  }

  TextStyle _parseNotionStyle(dynamic styleDirectives) {
    var style = const TextStyle();
    if (styleDirectives is List) {
      for (final directive in styleDirectives) {
        if (directive is List && directive.isNotEmpty) {
          final code = directive[0];
          switch (code) {
            case 'b':
              style = style.merge(const TextStyle(fontWeight: FontWeight.bold));
              break;
            case 'i':
              style = style.merge(const TextStyle(fontStyle: FontStyle.italic));
              break;
            case 'u':
              style = style.merge(
                const TextStyle(decoration: TextDecoration.underline),
              );
              break;
            case 's':
              style = style.merge(
                const TextStyle(decoration: TextDecoration.lineThrough),
              );
              break;
            case 'c': // color
              if (directive.length > 1) {
                final colorName = directive[1];
                final color = _resolveColor(colorName);
                if (color != null) {
                  style = style.merge(TextStyle(color: color));
                }
              }
              break;
            case 'h': // highlight
              if (directive.length > 1) {
                final colorName = directive[1];
                final color = _resolveColor(colorName);
                if (color != null) {
                  style = style.merge(TextStyle(backgroundColor: color));
                }
              }
              break;
          }
        }
      }
    }
    return style;
  }

  Color? _resolveColor(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'pink':
        return Colors.pink;
      case 'gray':
        return Colors.grey;
    }
    return null;
  }

  String _extractPlainText(dynamic titleProperty) {
    if (titleProperty is List && titleProperty.isNotEmpty) {
      final buffer = StringBuffer();
      for (final piece in titleProperty) {
        if (piece is List && piece.isNotEmpty) {
          final textSegment = piece[0];
          if (textSegment is String) {
            buffer.write(textSegment);
          }
        }
      }
      return buffer.toString();
    }
    return '';
  }

  String? _extractImageUrl(dynamic sourceProperty) {
    if (sourceProperty is List && sourceProperty.isNotEmpty) {
      final first = sourceProperty[0];
      if (first is List && first.isNotEmpty) {
        return first[0]?.toString();
      }
    }
    return null;
  }
}
