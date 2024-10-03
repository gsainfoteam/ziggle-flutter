import 'package:ziggle/app/modules/core/domain/enums/language.dart';

abstract class AiRepository {
  Future<String> translate({
    required String text,
    required Language targetLang,
  });
}
