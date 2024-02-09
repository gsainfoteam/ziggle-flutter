import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../models/token_model.dart';
import '../models/user_model.dart';
import 'authorize_interceptor.dart';

part 'user_api.g.dart';

@RestApi(baseUrl: 'user/')
@injectable
abstract class UserApi {
  @factoryMethod
  factory UserApi(Dio dio) = _UserApi;

  @GET('login')
  Future<TokenModel> login(
    @Query('code') String code, [
    @Query('type') String type = 'flutter',
  ]);

  @GET('info')
  Future<UserModel> info();

  @POST('logout')
  Future logout();

  @POST('refresh')
  @Extra({AuthorizeInterceptor.retriedKey: true})
  Future<TokenModel> refresh();

  @POST('fcm')
  Future updateFcmToken(@Field('fcm_token') String fcmToken);
}
