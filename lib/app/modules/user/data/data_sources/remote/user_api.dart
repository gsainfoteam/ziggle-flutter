import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/authorize_interceptor.dart';
import 'package:ziggle/app/modules/user/data/models/token_model.dart';
import 'package:ziggle/app/modules/user/data/models/user_model.dart';

part 'user_api.g.dart';

@injectable
@RestApi(baseUrl: 'user/')
abstract class UserApi {
  @factoryMethod
  factory UserApi(Dio dio) = _UserApi;

  @GET('login')
  Future<TokenModel> login(
    @Query('code') String code, [
    @Query('type') String type = 'flutter',
  ]);

  @POST('refresh')
  @Extra({AuthorizeInterceptor.retriedKey: true})
  Future<TokenModel> refresh();

  @GET('info')
  Future<UserModel> info();
}
