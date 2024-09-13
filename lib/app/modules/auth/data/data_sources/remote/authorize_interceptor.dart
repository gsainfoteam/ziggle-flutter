import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/auth_api.dart';
import 'package:ziggle/app/modules/auth/domain/token_repository.dart';

@singleton
class AuthorizeInterceptor extends Interceptor {
  final TokenRepository _repository;
  static const retriedKey = '_retried';

  AuthorizeInterceptor(this._repository);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final dio = sl<Dio>();

    final statusCode = err.response?.statusCode;
    if (statusCode != 401) return handler.next(err);
    final token = await _repository.token.first;
    if (token == null) return handler.next(err);
    final retried = err.requestOptions.extra.containsKey(retriedKey);
    if (retried) return handler.next(err);
    err.requestOptions.extra[retriedKey] = true;
    try {
      final authApi = sl<AuthApi>();
      try {
        authApi.testTokenInfo();
      } catch (e) {
        try {
          final token = await authApi.refresh();
          await _repository.saveToken(token.accessToken);
        } catch (e) {
          await _repository.deleteToken();
          return handler.next(err);
        }
      }
      final retriedResponse = await dio.fetch(err.requestOptions);
      return handler.resolve(retriedResponse);
    } on DioException {
      return super.onError(err, handler);
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_repository.tokenExpiration != null) {
      if (DateTime.now().isAfter(_repository.tokenExpiration!)) {
        try {
          final authApi = sl<AuthApi>();
          final token = await authApi.refresh();
          await _repository.saveToken(token.accessToken);
        } catch (_) {}
      }
    }
    final token = await _repository.token.first;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
