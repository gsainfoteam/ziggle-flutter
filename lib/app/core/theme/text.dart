import 'package:flutter/widgets.dart';
import 'package:ziggle/app/core/values/colors.dart';

abstract class TextStyles {
  TextStyles._();

  static const defaultStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Palette.black,
  );

  static const articleWriterTitleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const articleTitleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const articleCardTitleStyle = TextStyle(
    fontSize: 20,
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

  static const secondaryLabelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Palette.secondaryText,
  );

  static const tagStyle = TextStyle(
    color: Palette.primaryColor,
    fontSize: 10,
  );

  static const ddayStyle = TextStyle(
    color: Palette.white,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static const articleCardAuthorStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static const tooltipStyle = TextStyle(
    color: Palette.white,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}
