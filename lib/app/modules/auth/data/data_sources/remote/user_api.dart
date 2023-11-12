import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/auth/data/models/user_model.dart';

part 'user_api.g.dart';

@injectable
@RestApi(baseUrl: 'user/')
abstract class UserApi {
  @factoryMethod
  factory UserApi(Dio dio) = _UserApi;

  // @GET('login')
  // Future<LoginResponse> login(@Query('code') String authCode);

  // @POST('refresh')
  // Future<LoginResponse> refresh();

  @POST('logout')
  Future logout(@Field('access_token') String accessToken);

  @GET('info')
  Future<UserModel> userInfo();

  @POST('fcm')
  Future updateFcmToken(@Field('fcm_token') String fcmToken);
}
