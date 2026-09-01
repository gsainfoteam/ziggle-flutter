import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/auth_api.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/oauth_repository.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';

@Singleton(as: AuthRepository)
class RestAuthRepository implements AuthRepository {
  final AuthApi _authApi;
  final TokenRepository _tokenRepository;
  final CookieManager _cookieManager;
  final OAuthRepository _oAuthRepository;

  RestAuthRepository(
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

  /// 토큰 보유 여부만으로 판단한다.
  /// 토큰의 유효성은 AuthorizeInterceptor 의 refresh 가 담당하고,
  /// 프로필 조회 실패(미동의 등)는 로그아웃과 별개의 문제이므로 여기서 섞지 않는다.
  @override
  Stream<bool> get isSignedIn =>
      _tokenRepository.token.map((t) => t != null).distinct();

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
