import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

abstract class AppTheme {
  AppTheme._();

  static final theme = ThemeData(
    scaffoldBackgroundColor: Palette.white,
  );
}
