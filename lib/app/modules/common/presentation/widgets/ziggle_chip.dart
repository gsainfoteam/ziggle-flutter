import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleChip extends StatelessWidget {
  const ZiggleChip({
    super.key,
    this.chipColor = Palette.primary,
    this.labelColor = Palette.white,
    required this.label,
  });

  final Color chipColor;
  final Color labelColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> spans = _parseLabel(label);

    return Container(
      height: 24.0,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: IntrinsicWidth(
        child: Center(
          child: RichText(
            text: TextSpan(
              children: spans,
              style: TextStyle(
                color: labelColor,
                fontWeight: FontWeight.normal,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<TextSpan> _parseLabel(String label) {
    final List<TextSpan> spans = [];
    final RegExp numberRegExp = RegExp(r'\d+');

    final nonNumericParts = label.split(numberRegExp);
    final List<RegExpMatch> numericParts =
        numberRegExp.allMatches(label).toList();

    for (int i = 0; i < nonNumericParts.length; i++) {
      spans.add(
        TextSpan(
          text: nonNumericParts[i],
        ),
      );

      if (i < numericParts.length) {
        spans.add(
          TextSpan(
            text: numericParts[i].group(0),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        );
      }
    }

    return spans;
  }
}
