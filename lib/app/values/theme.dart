import 'package:flutter/material.dart';
import 'package:ziggle/app/values/fonts.dart';
import 'package:ziggle/app/values/palette.dart';

abstract class AppTheme {
  static final theme = ThemeData(
    colorSchemeSeed: Palette.primary100,
    brightness: Brightness.light,
    fontFamily: Pretendard.fontFamily,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    scaffoldBackgroundColor: Palette.background100,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      toolbarHeight: 40,
      scrolledUnderElevation: 0,
      backgroundColor: Palette.background100,
    ),
    chipTheme: const ChipThemeData(
      elevation: 0,
      pressElevation: 0,
      backgroundColor: Palette.background200,
      padding: EdgeInsets.zero,
    ),
    dividerColor: Palette.borderGreyLight,
  );
}
