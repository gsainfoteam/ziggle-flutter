import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/auth/data/services/token_refresh_service.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';

class SkipAuthorize extends Extra {
  static const _data = {AuthorizeInterceptor._skipKey: true};
  const SkipAuthorize() : super(_data);
}

abstract class AuthorizeInterceptor extends Interceptor {
  final TokenRepository repository;
  static const _authorizeRetriedKey = '_authorizeRetried';
  static const _skipKey = '_skip';

  AuthorizeInterceptor(this.repository);

  TokenRefreshService get tokenRefreshService;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.skip) return handler.next(options);

    try {
      await tokenRefreshService.mutex.acquireRead();
      final token = await repository.token.first;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    } finally {
      tokenRefreshService.mutex.release();
    }
  }

  Dio getDio();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final dio = getDio();
    final statusCode = err.response?.statusCode;
    if (err.requestOptions.skip) return handler.next(err);
    if (statusCode != 401) return handler.next(err);
    final token = await repository.token.first;
    if (token == null) return handler.next(err);
    if (err.requestOptions.authorizeRetried) return handler.next(err);
    err.requestOptions.authorizeRetried = true;

    try {
      if (!(await tokenRefreshService.refresh())) return handler.next(err);
      final retriedResponse = await dio.fetch(err.requestOptions);
      return handler.resolve(retriedResponse);
    } on DioException {
      return super.onError(err, handler);
    }
  }
}

extension _RequestOptionsX on RequestOptions {
  bool get authorizeRetried =>
      extra.containsKey(AuthorizeInterceptor._authorizeRetriedKey)
      ? extra[AuthorizeInterceptor._authorizeRetriedKey] as bool
      : false;
  set authorizeRetried(bool value) =>
      extra[AuthorizeInterceptor._authorizeRetriedKey] = value;

  bool get skip => extra.containsKey(AuthorizeInterceptor._skipKey);
}
