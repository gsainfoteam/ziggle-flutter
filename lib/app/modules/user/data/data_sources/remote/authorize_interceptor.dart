import 'package:dio/dio.dart';
import 'package:mutex/mutex.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/user_api.dart';
import 'package:ziggle/app/modules/user/domain/repositories/token_repository.dart';

abstract class AuthorizeInterceptor extends Interceptor {
  final TokenRepository repository;
  static const retriedKey = '_retried';
  final mutex = ReadWriteMutex();

  AuthorizeInterceptor(this.repository);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    if (statusCode != 401) return handler.next(err);
    final token = await repository.token.first;
    if (token == null) return handler.next(err);
    if (err.requestOptions.retried) return handler.next(err);
    err.requestOptions.retried = true;

    try {
      if (!(await _refresh())) return handler.next(err);
      // final retriedResponse = await dio.fetch(err.requestOptions);
      // return handler.resolve(retriedResponse);
    } on DioException {
      return super.onError(err, handler);
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.retried) return handler.next(options);

    try {
      await mutex.acquireRead();
      final token = await repository.token.first;
      print('header token : $token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    } finally {
      mutex.release();
    }
  }

  Future<bool> _refresh() async {
    print('trying refresh');
    if (mutex.isWriteLocked) {
      await mutex.acquireRead();
      mutex.release();
      return true;
    }
    await mutex.acquireWrite();
    final userApi = sl<UserApi>();
    try {
      final token = await userApi.refresh();
      await repository.saveToken(token.accessToken);
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
