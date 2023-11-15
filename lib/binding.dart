import 'package:get/get.dart';
import 'package:ziggle/app/data/provider/api.dart';
import 'package:ziggle/app/data/provider/db.dart';

final initialBinding = BindingsBuilder(() {
  Get.lazyPut(() => ApiProvider(Get.find()), fenix: true);
  Get.lazyPut(() => DbProvider(), fenix: true);
});
