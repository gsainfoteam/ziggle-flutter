import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/notices/data/models/translate_model.dart';
import 'package:ziggle/app/modules/notices/data/models/translation_result_model.dart';

part 'ai_api.g.dart';

@injectable
@RestApi(baseUrl: 'ai/')
abstract class AiApi {
  @factoryMethod
  factory AiApi(Dio dio) = _AiApi;

  @POST('translate')
  Future<TranslationResultModel> translate(@Body() TranslateModel body);
}
