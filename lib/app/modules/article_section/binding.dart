import 'package:get/get.dart';
import 'package:ziggle/app/modules/article_section/controller.dart';

class ArticleSectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ArticleSectionController());
  }
}
