// ignore: implementation_imports
import 'package:dio/dio.dart';
import 'package:dio/src/dio/dio_for_native.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/groups_authorize_interceptor.dart';

@singleton
class GroupsDio extends DioForNative {
  GroupsDio(GroupsAuthorizeInterceptor authorizeInterceptor,
      CookieManager cookieManager) {
    interceptors.addAll([authorizeInterceptor, cookieManager]);
    interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
    ));
  }
}
