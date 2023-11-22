import 'package:flutter/material.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/app/modules/notices/domain/entities/tag_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

class NoticeTags extends StatelessWidget {
  final List<TagEntity> tags;
  const NoticeTags({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: tags
            .expand(
              (e) => [
                WidgetSpan(
                  child: _ArticleTag(
                    text: '#${e.name}',
                    color: e.isType ? Colors.purple : Palette.primaryColor,
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 4)),
              ],
            )
            .toList(),
      ),
      maxLines: 2,
      style: const TextStyle(height: 2),
    );
  }
}

class _ArticleTag extends StatelessWidget {
  final String text;
  final Color color;
  const _ArticleTag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyles.articleCardBodyStyle.copyWith(color: color),
      ),
    );
  }
}
