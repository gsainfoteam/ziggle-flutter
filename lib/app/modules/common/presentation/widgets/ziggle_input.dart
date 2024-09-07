import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleInput extends StatefulWidget {
  const ZiggleInput({
    super.key,
    required this.c,
    this.disabled = false,
    required this.hintText,
  });

  final TextEditingController c;
  final bool disabled;
  final String hintText;

  @override
  State<ZiggleInput> createState() => _ZiggleInputState();
}

class _ZiggleInputState extends State<ZiggleInput> {
  OutlineInputBorder _buildInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: 1.5,
        color: widget.disabled ? Palette.grayBorder : Palette.primary,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextFormField(
        controller: widget.c,
        style: const TextStyle(fontWeight: FontWeight.bold),
        readOnly: widget.disabled ? true : false,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Palette.lightGray),
          enabledBorder: _buildInputBorder(),
          focusedBorder: _buildInputBorder(),
        ),
      ),
    );
  }
}
