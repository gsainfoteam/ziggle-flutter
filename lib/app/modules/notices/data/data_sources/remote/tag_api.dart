import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/tag_model.dart';

part 'tag_api.g.dart';

@injectable
@RestApi(baseUrl: 'tag/')
abstract class TagApi {
  @factoryMethod
  factory TagApi(@Named('ziggleDio') Dio dio) = _TagApi;

  @GET('')
  Future<List<TagModel>> searchTags(@Query('search') String search);

  @GET('')
  Future<TagModel> findTag(@Query('name') String name);

  @POST('')
  Future<TagModel> createTag(@Field('name') String name);
}
