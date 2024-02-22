import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/repositories/token_repository.dart';
import 'user_api.dart';

@singleton
class AuthorizeInterceptor extends Interceptor {
  final TokenRepository _repository;
  final UserApi _api;
  final Dio _dio;
  static const retriedKey = '_retried';

  AuthorizeInterceptor(this._repository, this._api, this._dio) {
    _dio.interceptors.add(this);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    if (statusCode != 401) return handler.next(err);
    final token = await _repository.token.first;
    if (token == null) return handler.next(err);
    final retried = err.requestOptions.extra.containsKey(retriedKey);
    if (retried) return handler.next(err);
    try {
      final token = await _api.refresh();
      await _repository.saveToken(token.accessToken, token.expiresIn);
      return handler.resolve(await _dio.fetch(err.requestOptions));
    } on DioException {
      return super.onError(err, handler);
    }
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final expired = await _repository.hasExpired();
    try {
      if (expired) {
        final token = await _api.refresh();
        await _repository.saveToken(token.accessToken, token.expiresIn);
      }
    } catch (_) {}
    final token = await _repository.token.first;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
