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
          Pretendard.semiBold(),
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
          '3ffbacde6ab8411f1d2db54bb9b1f0b3ee2a738932033722cf0388c06aed1c93',
          1574352,
        );
  Pretendard.medium()
      : weight = FontWeight.w500,
        super(
          'd39e50e4bb52b4993b6a4eeb821a171254745bd824446af01e1f616b89fface0',
          1584068,
        );
  Pretendard.semiBold()
      : weight = FontWeight.w600,
        super(
          'c89bc43027dc7cde5726e96223376f8eec09302b2fc1f8147fd5b57cfc376118',
          1583704,
        );
  Pretendard.bold()
      : weight = FontWeight.w700,
        super(
          '2e91915fab54df71cc9598ebf608b2bdb54c6fe3c066ac61dff0bc44fca71cc7',
          1576660,
        );

  static const _fontBaseUrl = 'https://github.com/orioncactus/pretendard/raw/'
      '82b96cc92998eb1f5e60e40beb6d52cd136957a6/packages/'
      'pretendard/dist';

  @override
  String get url =>
      '$_fontBaseUrl/public/static/Pretendard-${_fontWeightMap[weight]}.otf';

  static const licenseUrl = '$_fontBaseUrl/LICENSE.txt';

  static void register() {
    DynamicFonts.register(
      Pretendard.fontFamily,
      Pretendard.fontsMap,
      eager: true,
    );
    DynamicFonts.getFont(Pretendard.fontFamily);
    LicenseRegistry.addLicense(() async* {
      final data = await Dio().get(licenseUrl);
      yield LicenseEntryWithLineBreaks([Pretendard.fontFamily], data.data);
    });
  }
}
