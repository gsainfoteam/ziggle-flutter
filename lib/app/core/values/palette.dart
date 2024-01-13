import 'package:flutter/material.dart';

abstract class Palette {
  Palette._();
  static const primary100 = Color(0xffff4500);
  static const primary200 = Color(0xffff7b3a);
  static const primary300 = Color(0xffffe49a);

  static const accent100 = Color(0xffff8c00);
  static const accent200 = Color(0xff8e3000);

  static const text100 = Color(0xff000000);
  static const text200 = Color(0xff2c2c2c);

  static const background100 = Color(0xffffffff);
  static const background200 = Color(0xfff5f5f5);
  static const background300 = Color(0xffcccccc);

  static const secondaryText = Color(0xff959595);
  static const white = Colors.white;
  static const black = Color(0xff252525);
  static const deselected = Color(0xffd6d6d6);
  static const placeholder = Color(0xffe3e3e3);
  static const light = Color(0xfff5f5f5);
  static const settings = Color(0xff344fae);
}
