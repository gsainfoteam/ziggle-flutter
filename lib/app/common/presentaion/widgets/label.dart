import 'package:flutter/cupertino.dart';
import 'package:ziggle/app/core/themes/text.dart';

class Label extends StatelessWidget {
  const Label({super.key, required this.icon, required this.label});

  final IconData? icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 4),
        Text(label, style: TextStyles.label),
      ],
    );
  }
}
