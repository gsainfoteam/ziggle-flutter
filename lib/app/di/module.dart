import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/authorize_interceptor.dart';

@module
abstract class AppModule {
  @preResolve
  @singleton
  Future<CookieJar> makeCookieJar() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    return PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("$appDocPath/.cookies/"),
    );
  }

  @singleton
  CookieManager getCookieManager(CookieJar cookieJar) =>
      CookieManager(cookieJar);

  @singleton
  Dio getDio(AuthorizeInterceptor authorizeInterceptor,
          CookieManager cookieManager) =>
      Dio()..interceptors.addAll([authorizeInterceptor, cookieManager]);

  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );
}
