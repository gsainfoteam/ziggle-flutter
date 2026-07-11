import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/api_authorize_interceptor.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/api_cookie_manager.dart';
import 'package:ziggle/app/modules/core/domain/enums/api_channel.dart';

@singleton
class ZiggleDio extends DioForNative {
  ZiggleDio(
    ApiAuthorizeInterceptor authorizeInterceptor,
    ApiCookieManager cookieManager,
  ) : super(BaseOptions(baseUrl: ApiChannel.byMode().ziggleBaseUrl)) {
    interceptors.addAll([authorizeInterceptor, cookieManager]);
  }
}
