import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/values/strings.dart';
import 'package:ziggle/app/data/provider/api.dart';
import 'package:ziggle/app/data/provider/db.dart';
import 'package:ziggle/app/data/provider/fcm.dart';
import 'package:ziggle/app/data/provider/jwt_interceptor.dart';
import 'package:ziggle/app/data/services/analytics/service.dart';
import 'package:ziggle/app/data/services/message/service.dart';
import 'package:ziggle/app/data/services/token/repository.dart';
import 'package:ziggle/app/data/services/user/repository.dart';
import 'package:ziggle/app/data/services/user/service.dart';

final initialBinding = BindingsBuilder(() {
  Get.lazyPut(
    () => ApiProvider(
      Dio()
        ..interceptors.addAll([
          JwtInterceptor(Get.find()),
        ]),
      baseUrl: apiBaseUrl,
    ),
    fenix: true,
  );
  Get.lazyPut(() => DbProvider(), fenix: true);

  Get.lazyPut(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
    fenix: true,
  );

  Get.lazyPut(() => UserRepository(Get.find(), Get.find()));
  Get.lazyPut(() => TokenRepository(Get.find()), fenix: true);
  Get.lazyPut(() => UserService(Get.find(), Get.find(), Get.find()));

  Get.lazyPut(() => FcmProvider());
  Get.put(MessageService(Get.find(), Get.find()));
  Get.lazyPut(() => AnalyticsService(Get.find()), fenix: true);
});
