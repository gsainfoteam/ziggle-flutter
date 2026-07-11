import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/authorize_interceptor.dart';
import 'package:ziggle/app/modules/auth/data/services/jwt_token_refresh_service.dart';
import 'package:ziggle/app/modules/auth/data/services/token_refresh_service.dart';
import 'package:ziggle/app/modules/core/data/dio/ziggle_dio.dart';

@singleton
class ApiAuthorizeInterceptor extends AuthorizeInterceptor {
  ApiAuthorizeInterceptor(super.repository);

  @override
  TokenRefreshService get tokenRefreshService => sl<JwtTokenRefreshService>();

  @override
  Dio getDio() => sl<ZiggleDio>();
}
