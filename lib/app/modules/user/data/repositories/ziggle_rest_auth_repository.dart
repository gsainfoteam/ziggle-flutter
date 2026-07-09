import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/auth_api.dart';
import 'package:ziggle/app/modules/auth/data/repositories/web_auth_2_oauth_repository.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/user_api.dart';
import 'package:ziggle/app/modules/user/data/repositories/rest_auth_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/ziggle_flutter_secure_storage_token_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/ziggle_web_auth_2_oauth_repository.dart';

@named
@Singleton(as: RestAuthRepository)
class ZiggleRestAuthRepository extends RestAuthRepository {
  final AuthApi _authApi;

  ZiggleRestAuthRepository(
    UserApi api,
    @Named.from(ZiggleFlutterSecureStorageTokenRepository)
    TokenRepository tokenRepository,
    CookieManager cookieManager,
    @Named.from(ZiggleWebAuth2OauthRepository)
    WebAuth2OAuthRepository oAuthRepository,
    this._authApi,
  ) : super(
        api: api,
        tokenRepository: tokenRepository,
        cookieManager: cookieManager,
        oAuthRepository: oAuthRepository,
      );

  @override
  Future<void> login() async {
    final idpToken = await oAuthRepository.getToken();
    final jwt = await _authApi.login('Bearer ${idpToken.accessToken}');
    await tokenRepository.saveToken(jwt.accessToken);
  }

  @override
  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (_) {}
    await tokenRepository.deleteToken();
    await cookieManager.cookieJar.deleteAll();
    await oAuthRepository.setRecentLogout();
  }
}
