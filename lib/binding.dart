import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/data/provider/api.dart';

final initialBinding = BindingsBuilder(() {
  Get.lazyPut(() => ApiProvider(Dio()));
});
