import 'package:ziggle/gen/strings.g.dart';

abstract class AiRepository {
  Future<String> translate({
    required String text,
    required AppLocale targetLang,
  });
}
