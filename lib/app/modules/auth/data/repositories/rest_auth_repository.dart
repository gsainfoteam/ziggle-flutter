import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/auth_api.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/oauth_repository.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/user_api.dart';

@Singleton(as: AuthRepository)
class RestAuthRepository implements AuthRepository {
  final UserApi _userApi;
  final AuthApi _authApi;
  final TokenRepository _tokenRepository;
  final CookieManager _cookieManager;
  final OAuthRepository _oAuthRepository;

  RestAuthRepository(
    this._userApi,
    this._authApi,
    this._tokenRepository,
    this._cookieManager,
    this._oAuthRepository,
  );

  @override
  Future<void> login() async {
    final idpToken = await _oAuthRepository.getToken();
    final jwt = await _authApi.login('Bearer ${idpToken.accessToken}');
    await _tokenRepository.saveToken(jwt.accessToken);
  }

  @override
  Stream<bool> get isSignedIn => _tokenRepository.token.asyncMap((t) async {
    if (t == null) {
      return false;
    }
    try {
      await _userApi.info();
      return true;
    } on DioException {
      return false;
    }
  });

  @override
  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (_) {}
    await _tokenRepository.deleteToken();
    await _cookieManager.cookieJar.deleteAll();
    await _oAuthRepository.setRecentLogout();
  }
}
