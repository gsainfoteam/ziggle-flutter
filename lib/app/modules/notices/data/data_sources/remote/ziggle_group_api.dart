import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/core/data/dio/ziggle_dio.dart';
import 'package:ziggle/app/modules/notices/data/models/group_token_model.dart';
part 'ziggle_group_api.g.dart';

@injectable
@RestApi(baseUrl: 'group/')
abstract class ZiggleGroupApi {
  @factoryMethod
  factory ZiggleGroupApi(ZiggleDio dio) = _ZiggleGroupApi;

  @POST('token')
  Future<GroupTokenModel> getGroupToken();
}
