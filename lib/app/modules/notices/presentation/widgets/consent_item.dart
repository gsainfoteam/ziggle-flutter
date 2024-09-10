import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_checkbox.dart';
import 'package:ziggle/app/values/palette.dart';

class ConsentItem extends StatefulWidget {
  const ConsentItem({
    super.key,
    required this.title,
    required this.description,
    this.isChecked = false,
  });

  final String title;
  final String description;
  final bool isChecked;

  @override
  State<ConsentItem> createState() => _ConsentItemState();
}

class _ConsentItemState extends State<ConsentItem> {
  late bool isChecked;

  @override
  void initState() {
    isChecked = widget.isChecked;
    super.initState();
  }

  _toggleCheck(bool newValue) {
    setState(() {
      isChecked = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onToggle: (newValue) => _toggleCheck(newValue),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Palette.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.45,
                  ),
                ),
                Text(
                  widget.description,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
