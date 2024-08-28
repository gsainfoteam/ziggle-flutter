import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleTextField extends StatefulWidget {
  const ZiggleTextField({
    super.key,
    this.label,
    this.hint,
    this.keyboardType,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.autofillHints,
    this.autocorrect = true,
  });

  final String? label;
  final String? hint;
  final TextInputType? keyboardType;
  final String? initialValue;
  final void Function(String)? onChanged;
  final String? Function(String)? validator;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final bool autocorrect;

  @override
  State<ZiggleTextField> createState() => ZiggleTextFieldState();
}

class ZiggleTextFieldState extends State<ZiggleTextField> {
  bool _shouldValidate = false;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_focusNodeListener)
      ..dispose();
    super.dispose();
  }

  void _focusNodeListener() {
    if (!_focusNode.hasFocus) {
      setState(() => _shouldValidate = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      focusNode: _focusNode,
      autocorrect: widget.autocorrect,
      autofillHints: widget.autofillHints,
      obscureText: widget.obscureText,
      validator: (v) => widget.validator?.call(v ?? ''),
      autovalidateMode: widget.validator != null && _shouldValidate
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      initialValue: widget.initialValue,
      cursorWidth: 2,
      cursorColor: Palette.primary100,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Palette.primary100, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Palette.primary100, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Palette.primary100, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Palette.text400,
        ),
        hintText: widget.hint,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Palette.black,
            ),
          ),
          const SizedBox(height: 10),
        ],
        field,
      ],
    );
  }
}
