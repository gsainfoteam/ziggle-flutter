import 'package:dio/dio.dart';
import 'package:mutex/mutex.dart';
import 'package:ziggle/app/modules/user/domain/repositories/token_repository.dart';

abstract class AuthorizeInterceptor extends Interceptor {
  final TokenRepository repository;
  static const retriedKey = '_retried';
  final mutex = ReadWriteMutex();

  AuthorizeInterceptor(this.repository);

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
}

extension _RequestOptionsX on RequestOptions {
  bool get retried => extra.containsKey(AuthorizeInterceptor.retriedKey);
}
