import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ziggle/app/modules/core/data/repositories/fcm_repository.dart';
import 'package:ziggle/app/modules/core/domain/repositories/push_message_repository.dart';

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
  Dio getDio(CookieJar cookieJar) =>
      Dio()..interceptors.add(CookieManager(cookieJar));

  FlutterSecureStorage getFlutterSecureStorage() => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );
  PushMessageRepository getPushMessageRepository(FcmRepository r) => r;
}
