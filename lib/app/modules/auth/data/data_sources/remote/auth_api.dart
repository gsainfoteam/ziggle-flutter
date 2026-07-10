import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/authorize_interceptor.dart';
import 'package:ziggle/app/modules/auth/data/models/auth_token_model.dart';
import 'package:ziggle/app/modules/core/data/dio/ziggle_dio.dart';

part 'auth_api.g.dart';

@injectable
@RestApi(baseUrl: 'auth/')
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(ZiggleDio dio) = _AuthApi;

  @POST('login')
  @SkipAuthorize()
  Future<AuthTokenModel> login(@Header('Authorization') String authorization);

  @POST('refresh')
  @SkipAuthorize()
  Future<AuthTokenModel> refresh();

  @POST('logout')
  Future<void> logout();
}
