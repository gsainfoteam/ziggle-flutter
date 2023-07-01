import 'package:flutter/widgets.dart';
import 'package:ziggle/app/core/values/colors.dart';

abstract class TextStyles {
  TextStyles._();

  static const defaultStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Palette.black,
  );

  static const titleTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Palette.black,
  );

  static const label = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Palette.black,
  );
}
