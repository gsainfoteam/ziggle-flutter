import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_checkbox.dart';
import 'package:ziggle/app/values/palette.dart';

class ConsentItem extends StatelessWidget {
  const ConsentItem({
    super.key,
    required this.title,
    required this.description,
    required this.isChecked,
    required this.onChanged,
  });

  final String title;
  final String description;
  final bool isChecked;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.medium1,
      decoration: ShapeDecoration(
        color: isChecked ? Palette.primaryLight : Palette.grayLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ZiggleCheckbox(
            onToggle: onChanged,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Palette.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.45,
                  ),
                ),
                Text(
                  description,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
