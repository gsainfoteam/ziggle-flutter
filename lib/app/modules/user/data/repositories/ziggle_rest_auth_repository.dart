import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/user_api.dart';
import 'package:ziggle/app/modules/user/data/repositories/flutter_secure_storage_token_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/rest_auth_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/ziggle_flutter_secure_storage_token_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/ziggle_web_auth_2_oauth_repository.dart';

@named
@Singleton(as: RestAuthRepository)
class ZiggleRestAuthRepository extends RestAuthRepository {
  ZiggleRestAuthRepository(
      UserApi api,
      @Named.from(ZiggleFlutterSecureStorageTokenRepository)
      FlutterSecureStorageTokenRepository tokenRepository,
      CookieManager cookieManager,
      ZiggleWebAuth2OauthRepository oAuthRepository)
      : super(
            api: api,
            tokenRepository: tokenRepository,
            cookieManager: cookieManager,
            oAuthRepository: oAuthRepository);
}
