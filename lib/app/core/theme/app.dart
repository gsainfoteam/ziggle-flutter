import 'package:flutter/material.dart';
import 'package:ziggle/app/core/theme/font.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/values/colors.dart';

final appTheme = ThemeData(
  fontFamily: Pretendard.fontFamily,
  useMaterial3: true,
  scaffoldBackgroundColor: Palette.white,
  brightness: Brightness.light,
  primaryColor: Palette.primaryColor,
  splashFactory: NoSplash.splashFactory,
  hintColor: Palette.placeholder,
  colorScheme: ColorScheme.fromSeed(seedColor: Palette.primaryColor),
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
    selectedItemColor: Palette.primaryColor,
    unselectedItemColor: Palette.secondaryText,
    selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  ),
);
