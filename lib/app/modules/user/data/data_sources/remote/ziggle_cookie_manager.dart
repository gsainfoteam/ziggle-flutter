import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:injectable/injectable.dart';

@singleton
class ZiggleCookieManager extends CookieManager {
  ZiggleCookieManager(super.cookieJar);
}
