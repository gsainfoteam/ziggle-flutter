import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/domain/enums/api_channel.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/ziggle_authorize_interceptor.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/ziggle_cookie_manager.dart';

@singleton
class ZiggleDio extends DioForNative {
  ZiggleDio(ZiggleAuthorizeInterceptor authorizeInterceptor,
      ZiggleCookieManager cookieManager)
      : super(BaseOptions(baseUrl: ApiChannel.byMode().ziggleBaseUrl)) {
    interceptors.addAll([authorizeInterceptor, cookieManager]);
  }
}
