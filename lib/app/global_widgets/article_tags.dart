import 'package:flutter/widgets.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/values/colors.dart';

class ArticleTags extends StatelessWidget {
  final List<String> tags;
  const ArticleTags({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: tags.map((e) => _ArticleTag(text: '#$e')).toList(),
    );
  }
}

class _ArticleTag extends StatelessWidget {
  final String text;
  const _ArticleTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.primaryColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(text, style: TextStyles.tagStyle),
    );
  }
}
