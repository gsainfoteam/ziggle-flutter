import 'package:flutter/material.dart';
import 'package:ziggle/app/core/themes/font.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/values/palette.dart';

final appTheme = ThemeData(
  fontFamily: Pretendard.fontFamily,
  scaffoldBackgroundColor: Palette.white,
  brightness: Brightness.light,
  primaryColor: Palette.primary100,
  splashFactory: NoSplash.splashFactory,
  hintColor: Palette.placeholder,
  colorScheme: ColorScheme.fromSeed(seedColor: Palette.primary100),
  textTheme: const TextTheme(
    bodyMedium: TextStyles.defaultStyle,
    titleLarge: TextStyles.titleTextStyle,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xb2ffffff),
    surfaceTintColor: Color(0xb2ffffff),
    foregroundColor: Palette.black,
    centerTitle: true,
    elevation: 0,
  ),
  dividerTheme: const DividerThemeData(
    color: Palette.light,
    thickness: 16,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Palette.white,
    elevation: 0,
    selectedItemColor: Palette.primary100,
    unselectedItemColor: Palette.secondaryText,
    selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  ),
);
