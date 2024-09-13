import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class Emojis {
  Emojis._();
  static const _kFontFam = 'TossFace';

  static const crying = IconData(0x1f62d, fontFamily: _kFontFam);
  static const surprised = IconData(0x1f62e, fontFamily: _kFontFam);
  static const thinking = IconData(0x1f914, fontFamily: _kFontFam);
  static const anguished = IconData(0x1f627, fontFamily: _kFontFam);

  static void register() {
    LicenseRegistry.addLicense(() async* {
      const path = 'assets/fonts/TossFace/LICENSE';
      final license = await rootBundle.loadString(path);
      yield LicenseEntryWithLineBreaks(['TossFace'], license);
    });
  }
}
