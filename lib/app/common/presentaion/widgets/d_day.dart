import 'package:flutter/material.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/values/palette.dart';

class DDay extends StatelessWidget {
  final int dDay;
  get _label => dDay > 0
      ? 'D - $dDay'
      : dDay < 0
          ? 'D + ${dDay.abs()}'
          : 'D - Day';
  const DDay({super.key, required this.dDay});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
      decoration: BoxDecoration(
        color: Palette.primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(_label, style: TextStyles.ddayStyle),
    );
  }
}
