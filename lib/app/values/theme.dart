import 'package:flutter/material.dart';
import 'package:ziggle/app/values/fonts.dart';
import 'package:ziggle/app/values/palette.dart';

abstract class AppTheme {
  static final theme = ThemeData(
    fontFamily: Pretendard.fontFamily,
    appBarTheme: const AppBarTheme(
      toolbarHeight: 40,
      scrolledUnderElevation: 0,
    ),
    chipTheme: const ChipThemeData(
      elevation: 0,
      pressElevation: 0,
      backgroundColor: Palette.background200,
      padding: EdgeInsets.zero,
    ),
  );
}
