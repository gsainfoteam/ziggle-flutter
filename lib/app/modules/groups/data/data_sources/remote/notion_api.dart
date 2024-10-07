import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'notion_api.g.dart';

@injectable
@RestApi(baseUrl: 'notion/')
abstract class NotionApi {
  @factoryMethod
  factory NotionApi(@Named('ziggleDio') Dio dio) = _NotionApi;

  // @GET('{pageId}')
  // Future<Map<String, dynamic>> getGroups(@Path('pageId') int pageId);
}
