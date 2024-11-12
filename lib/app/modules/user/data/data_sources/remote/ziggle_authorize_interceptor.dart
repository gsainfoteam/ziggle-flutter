import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/core/data/dio/ziggle_dio.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/authorize_interceptor.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/user_api.dart';
import 'package:ziggle/app/modules/user/data/repositories/ziggle_flutter_secure_storage_token_repository.dart';

@singleton
class ZiggleAuthorizeInterceptor extends AuthorizeInterceptor {
  final String identifier = "ZiggleInterceptor";

  ZiggleAuthorizeInterceptor(
    @Named.from(ZiggleFlutterSecureStorageTokenRepository) super.repository,
  );

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final dio = sl<ZiggleDio>();
    final statusCode = err.response?.statusCode;
    if (statusCode != 401) return handler.next(err);
    final token = await repository.token.first;
    if (token == null) return handler.next(err);
    if (err.requestOptions.retried) return handler.next(err);
    err.requestOptions.retried = true;

    try {
      if (!(await _refresh())) return handler.next(err);
      final retriedResponse = await dio.fetch(err.requestOptions);
      return handler.resolve(retriedResponse);
    } on DioException {
      return super.onError(err, handler);
    }
  }

  Future<bool> _refresh() async {
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
