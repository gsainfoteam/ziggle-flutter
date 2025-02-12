import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/core/data/dio/groups_dio.dart';

part 'notion_api.g.dart';

@injectable
@RestApi(baseUrl: 'notion/')
abstract class NotionApi {
  @factoryMethod
  factory NotionApi(GroupsDio dio) = _NotionApi;

  @GET('{pageId}')
  Future<String> getGroups(@Path('pageId') String pageId);
}
