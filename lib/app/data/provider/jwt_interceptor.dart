import 'package:dio/dio.dart';
import 'package:ziggle/app/data/services/token/repository.dart';

class JwtInterceptor extends Interceptor {
  final TokenRepository _repository;
  String? _token;

  JwtInterceptor(this._repository) {
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
      await _repository.deleteToken();
    }
    super.onError(err, handler);
  }
}
