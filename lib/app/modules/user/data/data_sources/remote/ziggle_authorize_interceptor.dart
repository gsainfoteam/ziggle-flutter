import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/authorize_interceptor.dart';
import 'package:ziggle/app/modules/auth/data/services/token_refresh_service.dart';
import 'package:ziggle/app/modules/core/data/dio/ziggle_dio.dart';
import 'package:ziggle/app/modules/user/data/repositories/ziggle_flutter_secure_storage_token_repository.dart';
import 'package:ziggle/app/modules/user/data/services/ziggle_token_refresh_service.dart';

@singleton
class ZiggleAuthorizeInterceptor extends AuthorizeInterceptor {
  final String identifier = "ZiggleInterceptor";

  ZiggleAuthorizeInterceptor(
    @Named.from(ZiggleFlutterSecureStorageTokenRepository) super.repository,
  );

  @override
  TokenRefreshService get tokenRefreshService => sl<ZiggleTokenRefreshService>();

  @override
  Dio getDio() => sl<ZiggleDio>();
}
