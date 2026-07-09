import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/auth_api.dart';
import 'package:ziggle/app/modules/auth/data/services/token_refresh_service.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';

@singleton
class JwtTokenRefreshService implements TokenRefreshService {
  final TokenRepository _repository;
  final AuthApi _authApi;

  @override
  final mutex = ReadWriteMutex();

  JwtTokenRefreshService(this._repository, this._authApi);

  @override
  Future<bool> refresh() async {
    if (mutex.isWriteLocked) {
      await mutex.acquireRead();
      mutex.release();
      final token = await _repository.token.first;
      return token != null;
    }
    await mutex.acquireWrite();
    try {
      final res = await _authApi.refresh();
      await _repository.saveToken(res.accessToken);
      return true;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        await _repository.deleteToken();
      }
      return false;
    } finally {
      mutex.release();
    }
  }
}
