import 'package:get/get.dart';
import 'package:ziggle/app/modules/article_image/controller.dart';

class ArticleImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ArticleImageController());
  }
}
