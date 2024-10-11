import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/base_auth_api.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/user_api.dart';
import 'package:ziggle/app/modules/user/domain/repositories/auth_repository.dart';
import 'package:ziggle/app/modules/user/domain/repositories/oauth_repository.dart';
import 'package:ziggle/app/modules/user/domain/repositories/token_repository.dart';

abstract class RestAuthRepository implements AuthRepository {
  final BaseAuthApi _api;
  final TokenRepository _tokenRepository;
  final CookieManager _cookieManager;
  final OAuthRepository _oAuthRepository;

  RestAuthRepository({
    required UserApi api,
    required TokenRepository tokenRepository,
    required CookieManager cookieManager,
    required OAuthRepository oAuthRepository,
  })  : _api = api,
        _tokenRepository = tokenRepository,
        _cookieManager = cookieManager,
        _oAuthRepository = oAuthRepository;

  @override
  Future<void> login() async {
    final code = await _oAuthRepository.getAuthorizationCode();
    final result = await _api.login(code.authCode);
    await _tokenRepository.saveToken(result.accessToken);
  }

  @override
  Stream<bool> get isSignedIn => _tokenRepository.token.asyncMap(
        (_) async {
          try {
            await _api.info();
            return true;
          } catch (_) {
            return false;
          }
        },
      );

  @override
  Future<void> logout() async {
    await _tokenRepository.deleteToken();
    await _cookieManager.cookieJar.deleteAll();
  }
}
