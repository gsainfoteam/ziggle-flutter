import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ziggle/app/modules/core/data/repositories/fcm_messaging_repository.dart';
import 'package:ziggle/app/modules/core/domain/repositories/messaging_repository.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/authorize_interceptor.dart';
import 'package:ziggle/app/modules/user/data/repositories/hive_setting_repository.dart';
import 'package:ziggle/app/modules/user/domain/repositories/developer_option_repository.dart';
import 'package:ziggle/app/modules/user/domain/repositories/language_setting_repository.dart';

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

  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

  LanguageSettingRepository getLanguageSettingRepository(
          HiveSettingRepository repo) =>
      repo;

  DeveloperOptionRepository getDeveloperOptionRepository(
          HiveSettingRepository repo) =>
      repo;
  MessagingRepository getMessagingRepository(FcmMessagingRepository repo) =>
      repo;
}
