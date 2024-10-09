import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/core/data/dio/ziggle_dio.dart';

import '../../models/tag_model.dart';

part 'tag_api.g.dart';

@injectable
@RestApi(baseUrl: 'tag/')
abstract class TagApi {
  @factoryMethod
  factory TagApi(ZiggleDio dio) = _TagApi;

  @GET('')
  Future<List<TagModel>> searchTags(@Query('search') String search);

  @GET('')
  Future<TagModel> findTag(@Query('name') String name);

  @POST('')
  Future<TagModel> createTag(@Field('name') String name);
}
