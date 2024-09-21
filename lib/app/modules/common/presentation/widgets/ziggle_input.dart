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
    this.style,
    this.focusNode,
    this.minLines,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final bool disabled;
  final String hintText;
  final void Function(String)? onChanged;
  final Widget? label;
  final bool showBorder;
  final TextStyle? style;
  final FocusNode? focusNode;
  final int? minLines;
  final int? maxLines;

  OutlineInputBorder _buildInputBorder(Color color) {
    if (!showBorder) {
      return const OutlineInputBorder(borderSide: BorderSide.none);
    }
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
    final field = TextFormField(
      minLines: minLines,
      maxLines: maxLines,
      focusNode: focusNode,
      controller: controller,
      readOnly: disabled,
      onChanged: onChanged,
      style: TextStyle(
        color: disabled ? Palette.gray : Palette.black,
      ).merge(style),
      decoration: InputDecoration(
        contentPadding: showBorder
            ? const EdgeInsets.symmetric(vertical: 10, horizontal: 16)
            : const EdgeInsets.symmetric(vertical: 10),
        hintText: hintText,
        hintStyle: const TextStyle(color: Palette.gray),
        enabledBorder: _buildInputBorder(Palette.gray),
        disabledBorder:
            _buildInputBorder(disabled ? Palette.gray : Palette.primary),
        focusedBorder:
            _buildInputBorder(disabled ? Palette.gray : Palette.primary),
      ),
    );

    if (label == null) return field;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DefaultTextStyle.merge(
          style: const TextStyle(
            color: Palette.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          child: label!,
        ),
        const SizedBox(height: 10),
        field,
      ],
    );
  }
}
