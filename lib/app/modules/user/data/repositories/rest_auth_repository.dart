import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/base_auth_api.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/oauth_repository.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';

abstract class RestAuthRepository implements AuthRepository {
  final BaseAuthApi api;
  final TokenRepository tokenRepository;
  final CookieManager cookieManager;
  final OAuthRepository oAuthRepository;

  RestAuthRepository({
    required this.api,
    required this.tokenRepository,
    required this.cookieManager,
    required this.oAuthRepository,
  });

  @override
  Future<void> login() async {
    final token = await oAuthRepository.getToken();
    await tokenRepository.saveToken(token.accessToken);
    if (token.refreshToken != null) {
      await tokenRepository.saveRefreshToken(token.refreshToken!);
    }
  }

  @override
  Stream<bool> get isSignedIn => tokenRepository.token.asyncMap((t) async {
    if (t == null) {
      return false;
    }
    try {
      await api.info();
      return true;
    } on DioException {
      return false;
    }
  });

  @override
  Future<void> logout() async {
    await tokenRepository.deleteToken();
    await cookieManager.cookieJar.deleteAll();
    await oAuthRepository.setRecentLogout();
  }
}
