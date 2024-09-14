import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/user_api.dart';
import 'package:ziggle/app/modules/user/domain/repositories/token_repository.dart';

@singleton
class AuthorizeInterceptor extends Interceptor {
  final TokenRepository _repository;
  static const retriedKey = '_retried';
  final mutex = ReadWriteMutex();

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
      await mutex.acquireWrite();
      final userApi = sl<UserApi>();
      try {
        await userApi.testTokenInfo();
      } catch (e) {
        try {
          final token = await userApi.refresh();
          await _repository.saveToken(token.accessToken);
        } catch (e) {
          await _repository.deleteToken();
          return handler.next(err);
        }
      } finally {
        mutex.release();
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
    if (!options.extra.containsKey(retriedKey)) {
      if (_repository.tokenExpiration != null) {
        if (DateTime.now().isAfter(_repository.tokenExpiration!)) {
          try {
            await mutex.acquireWrite();
            final userApi = sl<UserApi>();
            final token = await userApi.refresh();
            await _repository.saveToken(token.accessToken);
          } catch (_) {
            await _repository.deleteToken();
          } finally {
            mutex.release();
          }
        }
      }
    }
    try {
      if (!options.extra.containsKey(retriedKey)) {
        await mutex.acquireRead();
      }
      final token = await _repository.token.first;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    } finally {
      if (!options.extra.containsKey(retriedKey)) {
        mutex.release();
      }
    }
  }
}
