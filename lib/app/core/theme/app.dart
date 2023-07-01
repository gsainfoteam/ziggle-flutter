import 'package:flutter/material.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/gen/fonts.gen.dart';

final appTheme = ThemeData(
  fontFamily: FontFamily.notoSansKR,
  useMaterial3: true,
  textTheme: const TextTheme(
    bodyMedium: TextStyles.defaultStyle,
    titleLarge: TextStyles.titleTextStyle,
  ),
  scaffoldBackgroundColor: Palette.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Palette.white,
    foregroundColor: Palette.black,
    centerTitle: true,
    elevation: 0,
  ),
  dividerTheme: const DividerThemeData(
    color: Palette.light,
    thickness: 16,
  ),
);
