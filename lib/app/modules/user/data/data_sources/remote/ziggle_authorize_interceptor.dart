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
  Dio getDio() {
    return sl<ZiggleDio>();
  }

  @override
  Future<bool> refresh() async {
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
