import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/core/data/dio/ziggle_dio.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/authorize_interceptor.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/base_auth_api.dart';
import 'package:ziggle/app/modules/user/data/models/token_model.dart';
import 'package:ziggle/app/modules/user/data/models/user_model.dart';

part 'user_api.g.dart';

@injectable
@RestApi(baseUrl: 'user/')
abstract class UserApi extends BaseAuthApi {
  @factoryMethod
  factory UserApi(ZiggleDio dio) = _UserApi;

  @override
  @GET('login')
  Future<TokenModel> login(
    @Query('code') String code, [
    @Query('type') String type = 'flutter',
  ]);

  @POST('refresh')
  @Extra({AuthorizeInterceptor.retriedKey: true})
  Future<TokenModel> refresh();

  @override
  @GET('info')
  Future<UserModel> info();
}
