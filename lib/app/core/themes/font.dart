import 'package:dio/dio.dart';
import 'package:dynamic_fonts/dynamic_fonts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final _fontWeightMap = {
  FontWeight.w100: 'Thin',
  FontWeight.w200: 'ExtraLight',
  FontWeight.w300: 'Light',
  FontWeight.w400: 'Regular',
  FontWeight.w500: 'Medium',
  FontWeight.w600: 'SemiBold',
  FontWeight.w700: 'Bold',
  FontWeight.w800: 'ExtraBold',
  FontWeight.w900: 'Black',
};

class Pretendard extends DynamicFontsFile {
  static String fontFamily = 'Pretendard';
  final FontWeight weight;

  static Map<DynamicFontsVariant, DynamicFontsFile> get fontsMap =>
      Map.fromIterable(
        [
          Pretendard.regular(),
          Pretendard.medium(),
          Pretendard.bold(),
        ],
        key: (element) => element.variant,
      );

  DynamicFontsVariant get variant => DynamicFontsVariant(
        fontStyle: FontStyle.normal,
        fontWeight: weight,
      );
  Pretendard.regular()
      : weight = FontWeight.normal,
        super(
          '8bcbe0d9cb2d0f929b7f8477a67b1b6d221a3aff9fb964e987c48210a05a2d7c',
          1577404,
        );

  Pretendard.medium()
      : weight = FontWeight.w500,
        super(
          '357df8311e78f3970d488f0c06ed15447ec3e2e5afa750bfa09d1e9574f06f28',
          1587368,
        );
  Pretendard.bold()
      : weight = FontWeight.w700,
        super(
          '5723aee38eba20d9a126d0c6d0483e3296199768b270f8c5daeb10caf7a81ed2',
          1581456,
        );

  static const _fontBaseUrl = 'https://github.com/orioncactus/pretendard/raw/'
      'be7e9c3755918a97faca17085aefbefadc5b9df3/packages/'
      'pretendard/dist';

  @override
  String get url =>
      '$_fontBaseUrl/public/static/Pretendard-${_fontWeightMap[weight]}.otf';
  static const licenseUrl = '$_fontBaseUrl/LICENSE.txt';

  static void register() {
    DynamicFonts.register(Pretendard.fontFamily, Pretendard.fontsMap);
    LicenseRegistry.addLicense(() async* {
      final data = await Dio().get(licenseUrl);
      yield LicenseEntryWithLineBreaks([Pretendard.fontFamily], data.data);
    });
  }
}
