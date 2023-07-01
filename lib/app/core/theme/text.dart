import 'package:flutter/widgets.dart';
import 'package:ziggle/app/core/values/colors.dart';

abstract class TextStyles {
  TextStyles._();

  static const defaultStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Palette.black,
  );

  static const articleTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const titleTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const label = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}
