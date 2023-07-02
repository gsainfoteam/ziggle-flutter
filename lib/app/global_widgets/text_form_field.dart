import 'package:flutter/material.dart';
import 'package:ziggle/app/core/values/colors.dart';

class ZiggleTextFormField extends StatelessWidget {
  final String? hintText;
  final int? minLines;
  final int? maxLines;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const ZiggleTextFormField({
    super.key,
    this.hintText,
    this.minLines,
    this.maxLines,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: Palette.primaryColor,
        width: 1.5,
      ),
    );
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: border,
        enabledBorder: border,
      ),
    );
  }
}
