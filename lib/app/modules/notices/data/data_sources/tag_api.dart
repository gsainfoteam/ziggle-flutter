import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/notices/data/models/tag_model.dart';

part 'tag_api.g.dart';

@injectable
@RestApi(baseUrl: 'tag/')
abstract class TagApi {
  @factoryMethod
  factory TagApi(Dio dio) = _TagApi;

  @POST('')
  Future<TagModel> createTag(@Field('name') String tag);

  @GET('')
  Future<TagModel> findTag(@Query('name') String name);

  @DELETE('{id}')
  Future<void> deleteTag(@Path('id') String id);
}
