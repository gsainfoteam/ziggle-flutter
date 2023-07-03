import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/data/provider/api.dart';
import 'package:ziggle/app/data/provider/jwt_interceptor.dart';
import 'package:ziggle/app/data/services/token/repository.dart';
import 'package:ziggle/app/data/services/user/repository.dart';
import 'package:ziggle/app/data/services/user/service.dart';

final initialBinding = BindingsBuilder(() {
  Get.lazyPut(
    () => ApiProvider(
      Dio()..interceptors.add(JwtInterceptor(Get.find())),
    ),
  );

  Get.lazyPut(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );

  Get.lazyPut(() => UserRepository(Get.find()));
  Get.lazyPut(() => TokenRepository(Get.find()));
  Get.put(UserService(Get.find(), Get.find()));
});
