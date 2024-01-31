import 'package:flutter/material.dart';

abstract class Palette {
  Palette._();

  static const primary100 = Color(0xffff4500);
  static const primary200 = Color(0xffff7b3a);
  static const primary300 = Color(0xffffe49a);

  static const accent100 = Color(0xffff8c00);
  static const accent200 = Color(0xff8e3000);

  static const text100 = Color(0xff000000);
  static const black = text100;
  static const text200 = Color(0xff2c2c2c);
  static const text300 = Color(0xff6e6e73);
  static const textGreyDark = text300;
  static const text400 = Color(0xffb3b3b3);
  static const textGrey = text400;

  static const white = background100;
  static const background100 = Color(0xffffffff);
  static const background200 = Color(0xfff5f5f5);
  static const backgroundGreyLight = background200;
  static const background300 = Color(0xffcccccc);

  static const borderGreyLight = Color(0xffd6d6d6);
}
