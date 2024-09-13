import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/authorize_interceptor.dart';
import 'package:ziggle/app/modules/auth/data/models/token_model.dart';

part 'auth_api.g.dart';

@injectable
@RestApi(baseUrl: 'user')
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(Dio dio) = _AuthApi;

  @GET('login')
  Future<TokenModel> login(@Field('access_token') String accessToken);

  @POST('refresh')
  @Extra({AuthorizeInterceptor.retriedKey: true})
  Future<TokenModel> refresh();

  @GET('info')
  @Extra({AuthorizeInterceptor.retriedKey: true})
  Future testTokenInfo();
}
