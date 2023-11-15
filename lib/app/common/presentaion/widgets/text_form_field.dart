import 'package:flutter/material.dart';
import 'package:ziggle/app/core/values/palette.dart';

class ZiggleTextFormField extends StatelessWidget {
  final String? hintText;
  final int? minLines;
  final int? maxLines;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final InputDecoration? inputDecoration;
  final FocusNode? focusNode;
  final String? initialValue;

  const ZiggleTextFormField({
    super.key,
    this.hintText,
    this.minLines,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.inputDecoration,
    this.focusNode,
    this.initialValue,
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
      initialValue: initialValue,
      onFieldSubmitted: onSubmitted,
      minLines: minLines,
      maxLines: maxLines,
      focusNode: focusNode,
      decoration: (inputDecoration ?? const InputDecoration()).copyWith(
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
