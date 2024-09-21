import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/data/data_sources/remote/ai_api.dart';
import 'package:ziggle/app/modules/notices/data/models/translate_model.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/ai_repository.dart';
import 'package:ziggle/gen/strings.g.dart';

@Injectable(as: AiRepository)
class RestAiRepository implements AiRepository {
  final AiApi _api;

  RestAiRepository(this._api);

  @override
  Future<String> translate({
    required String text,
    required AppLocale targetLang,
  }) async {
    final result = await _api.translate(
      TranslateModel(text: text, targetLang: targetLang),
    );
    return result.text;
  }
}
