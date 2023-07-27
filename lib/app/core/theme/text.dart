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

  static const bigNormal = TextStyle(fontSize: 20);

  static const titleTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const label = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const link = TextStyle(
    fontSize: 16,
    color: Palette.secondaryText,
    decorationColor: Palette.secondaryText,
    decoration: TextDecoration.underline,
  );

  static const secondaryLabelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Palette.secondaryText,
  );

  static const ddayStyle = TextStyle(
    color: Palette.white,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static const articleCardAuthorStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const articleCardBodyStyle = TextStyle(fontSize: 12);

  static const tooltipStyle = TextStyle(
    color: Palette.white,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}
