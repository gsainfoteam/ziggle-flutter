import 'package:dio/dio.dart';
import 'package:mutex/mutex.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/oauth_api.dart';
import 'package:ziggle/app/modules/auth/data/models/token_request_with_refresh_model.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';

abstract class AuthorizeInterceptor extends Interceptor {
  final TokenRepository repository;
  static const retriedKey = '_retried';
  final mutex = ReadWriteMutex();
  final OAuthApi _oAuthApi;
  final String clientId;

  AuthorizeInterceptor(this.repository, this._oAuthApi,
      {required this.clientId});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.retried) return handler.next(options);

    try {
      await mutex.acquireRead();
      final token = await repository.token.first;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    } finally {
      mutex.release();
    }
  }

  Dio getDio();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final dio = getDio();
    final statusCode = err.response?.statusCode;
    if (statusCode != 401) return handler.next(err);
    final token = await repository.token.first;
    if (token == null) return handler.next(err);
    if (err.requestOptions.retried) return handler.next(err);
    err.requestOptions.retried = true;

    try {
      if (!(await refresh())) return handler.next(err);
      final retriedResponse = await dio.fetch(err.requestOptions);
      return handler.resolve(retriedResponse);
    } on DioException {
      return super.onError(err, handler);
    }
  }

  Future<bool> refresh() async {
    if (mutex.isWriteLocked) {
      await mutex.acquireRead();
      mutex.release();
      return true;
    }
    await mutex.acquireWrite();
    try {
      final token = await repository.refreshToken.first;
      if (token == null) return false;
      final res = await _oAuthApi.getTokenFromRefresh(
        TokenRequestWithRefreshModel(
          refreshToken: token,
          clientId: clientId,
        ),
      );
      await repository.saveToken(res.accessToken);
      await repository.saveRefreshToken(res.refreshToken!);
      return true;
    } catch (e) {
      await repository.deleteToken();
      return false;
    } finally {
      mutex.release();
    }
  }
}

extension _RequestOptionsX on RequestOptions {
  bool get retried => extra.containsKey(AuthorizeInterceptor.retriedKey);
  set retried(bool value) => extra[AuthorizeInterceptor.retriedKey] = value;
}
