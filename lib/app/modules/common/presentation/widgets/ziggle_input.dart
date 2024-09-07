import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleInput extends StatefulWidget {
  const ZiggleInput({
    super.key,
    required this.c,
    this.withButton = false,
    this.disabled = false,
    this.onPressed,
    required this.hintText,
  });

  final TextEditingController c;
  final bool withButton;
  final bool disabled;
  final String hintText;
  final VoidCallback? onPressed;

  @override
  State<ZiggleInput> createState() => _ZiggleInputState();
}

class _ZiggleInputState extends State<ZiggleInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.c,
              style: const TextStyle(fontWeight: FontWeight.bold),
              readOnly: widget.disabled ? true : false,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Palette.lightGray),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    color:
                        widget.disabled ? Palette.grayBorder : Palette.primary,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1.5,
                      color: widget.disabled
                          ? Palette.grayBorder
                          : Palette.primary),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 68,
            decoration: ShapeDecoration(
              color: widget.disabled ? Palette.lightGrayLight : Palette.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Center(
              child: GestureDetector(
                onTap: widget.onPressed,
                child: Text(
                  '입력',
                  style: TextStyle(
                    color: widget.disabled ? Palette.lightGray : Palette.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
