import 'package:get/get.dart';
import 'package:ziggle/app/modules/article/controller.dart';

class ArticleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ArticleController());
  }
}
