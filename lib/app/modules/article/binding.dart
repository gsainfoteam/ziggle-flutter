import 'package:get/get.dart';
import 'package:ziggle/app/modules/article/controller.dart';
import 'package:ziggle/app/modules/article/repository.dart';

class ArticleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ArticleController(ArticleRepository(Get.find())));
  }
}
