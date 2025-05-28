import 'package:dio/io.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/ziggle_authorize_interceptor.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/ziggle_cookie_manager.dart';

@singleton
class ZiggleDio extends DioForNative {
  ZiggleDio(ZiggleAuthorizeInterceptor authorizeInterceptor,
      ZiggleCookieManager cookieManager) {
    interceptors.addAll([authorizeInterceptor, cookieManager]);
  }
}
