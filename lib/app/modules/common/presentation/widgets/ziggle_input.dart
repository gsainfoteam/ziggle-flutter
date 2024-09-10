import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleInput extends StatelessWidget {
  const ZiggleInput({
    super.key,
    required this.controller,
    this.disabled = false,
    required this.hintText,
  });

  final TextEditingController controller;
  final bool disabled;
  final String hintText;

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
    return SizedBox(
      height: 48,
      child: TextFormField(
        controller: controller,
        readOnly: disabled ? true : false,
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
    );
  }
}
