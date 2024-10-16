import 'dart:ui';

abstract class Palette {
  Palette._();

  static const primary = Color(0xFFFF4500);
  static const primaryMedium = Color(0xFFFFE8DF);
  static const primaryLight = Color(0xFFFFF4F0);
  static const white = Color(0xFFFFFFFF);
  static const grayLight = Color(0xFFF8F8F8);
  static const grayMedium = Color(0xFFF0F0F0);
  static const gray = Color(0xFFB3B3B3);
  static const grayBorder = Color(0xFFD6D6D6);
  static const black = Color(0xFF252525);

  /// for dropdown default color
  static const grayText = Color(0xFF6E6E73);
}

extension ColorHex on Color {
  String get hex =>
      '#${value.toRadixString(16).padLeft(8, '0').substring(2, 8)}';
}
