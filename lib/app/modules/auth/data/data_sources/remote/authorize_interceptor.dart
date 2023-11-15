import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/user_api.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';

@singleton
class AuthorizeInterceptor extends Interceptor {
  final TokenRepository _repository;
  final UserApi _api;
  final Dio _dio;

  AuthorizeInterceptor(this._repository, this._api, this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final token = await _repository.read().first;
    if (statusCode == 401 && token != null) {
      if (err.requestOptions.extra.containsKey('_retried') ||
          err.requestOptions.uri.path.contains('/refresh')) {
        return super.onError(err, handler);
      }
      err.requestOptions.extra['_retried'] = true;
      try {
        final token = await _api.refresh();
        await _repository.save(token.accessToken);
        return handler.resolve(await _dio.fetch(err.requestOptions));
      } on DioException {
        return super.onError(err, handler);
      }
    }
    handler.next(err);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _repository.read().first;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
