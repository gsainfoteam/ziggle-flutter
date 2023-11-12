import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/user_api.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';

@singleton
class AuthorizeInterceptor extends Interceptor {
  final TokenRepository _repository;
  final UserApi _api;
  final Dio _dio;
  String? _token;

  AuthorizeInterceptor(this._repository, this._api, this._dio) {
    _repository.read().listen((token) {
      _token = token;
    });
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    if (statusCode == 401 && _token != null) {
      if (err.requestOptions.extra.containsKey('_retried') ||
          err.requestOptions.path.contains('/refresh')) {
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
    if (_token != null) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
