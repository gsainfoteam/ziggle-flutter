import 'package:dio/dio.dart';
import 'package:ziggle/app/data/provider/api.dart';
import 'package:ziggle/app/data/services/token/repository.dart';

class JwtInterceptor extends Interceptor {
  final TokenRepository _repository;
  final ApiProvider _provider;
  final Dio _dio;
  String? _token;

  JwtInterceptor(this._repository, this._provider, this._dio) {
    _repository.getToken().listen((token) {
      _token = token;
    });
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_token != null) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    super.onRequest(options, handler);
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
        final token = await _provider.refresh();
        await _repository.saveToken(token.accessToken);
        return handler.resolve(await _dio.fetch(err.requestOptions));
      } on DioException {
        return super.onError(err, handler);
      }
    }
    super.onError(err, handler);
  }
}
