import 'package:flutter/material.dart';

class NotionPageBuilder extends StatelessWidget {
  final Map<String, dynamic> blocksMap;

  const NotionPageBuilder({
    super.key,
    required this.blocksMap,
  });

  @override
  Widget build(BuildContext context) {
    final firstBlock =
        blocksMap.keys.firstWhere((id) => (blocksMap[id]['type'] == 'page'));
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: _buildPageBlock(firstBlock),
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
        return _buildSubPageBlock(properties, content, indentLevel);
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

  Widget _buildPageBlock(
    String firstBlockId,
  ) {
    final properties =
        blocksMap[firstBlockId]['properties'] as Map<String, dynamic>? ?? {};
    final content = blocksMap[firstBlockId]['content'] as List<dynamic>? ?? [];
    final pageTitle = _extractPlainText(properties['title']);
    final children = content
        .whereType<String>()
        .map((childId) => _buildBlock(childId, 0))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pageTitle,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildSubPageBlock(
    Map<String, dynamic> properties,
    List<dynamic> content,
    int indentLevel,
  ) {
    final subPageTitle = _extractPlainText(properties['title']);

    return InkWell(
      onTap: () {
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

  Widget _buildToggleBlock(
    Map<String, dynamic> properties,
    List<dynamic> content,
    int indentLevel,
  ) {
    final titleProperty = properties['title'];

    final childWidgets = content.map<Widget>((childId) {
      if (childId is String) {
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

  Widget _buildBulletedListBlock(
    Map<String, dynamic> properties,
    List<dynamic> content,
    int indentLevel,
  ) {
    final children = <Widget>[];

    final titleProperty = properties['title'];
    if (titleProperty != null) {
      children.add(_buildSingleBulletItem(titleProperty, indentLevel));
    }

    for (var childId in content) {
      if (childId is String) {
        final childBlock = blocksMap[childId];
        if (childBlock != null) {
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

  Widget _buildNumberedListBlock(
    Map<String, dynamic> properties,
    List<dynamic> content,
    int indentLevel,
  ) {
    final children = <Widget>[];
    int index = 1;

    final titleProperty = properties['title'];
    if (titleProperty != null) {
      children.add(_buildNumberedItemTitle(titleProperty, indentLevel));
    }

    for (var childId in content) {
      if (childId is String) {
        final childBlock = blocksMap[childId];
        if (childBlock != null) {
          final childType = childBlock['type'] as String? ?? 'unknown';
          if (childType == 'text') {
            children.add(
                _buildNumberedItemBlock(childBlock, index, indentLevel + 1));
            index++;
          } else {
            children.add(_buildBlock(childId, indentLevel + 1));
          }
        }
      }
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

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
