import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

abstract class AppTheme {
  AppTheme._();

  static final theme = ThemeData(
      scaffoldBackgroundColor: Palette.white,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Palette.primary,
        selectionColor: Palette.primary.withOpacity(0.4),
        selectionHandleColor: Palette.primary,
      ),
      cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
        primaryColor: Palette.primary,
      ));
}
