import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleInput extends StatelessWidget {
  const ZiggleInput({
    super.key,
    this.controller,
    this.disabled = false,
    required this.hintText,
    this.onChanged,
    this.label,
    this.showBorder = true,
  });

  final TextEditingController? controller;
  final bool disabled;
  final String hintText;
  final void Function(String)? onChanged;
  final Widget? label;
  final bool showBorder;

  OutlineInputBorder _buildInputBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: 1.5,
        color: color,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          DefaultTextStyle.merge(
            style: const TextStyle(
              color: Palette.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            child: label!,
          ),
          const SizedBox(height: 10),
        ],
        SizedBox(
          height: 48,
          child: TextFormField(
            controller: controller,
            readOnly: disabled ? true : false,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              hintText: hintText,
              hintStyle: const TextStyle(color: Palette.gray),
              enabledBorder: _buildInputBorder(Palette.gray),
              focusedBorder:
                  _buildInputBorder(disabled ? Palette.gray : Palette.primary),
            ),
          ),
        ),
      ],
    );
  }
}
