import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ziggle/app/data/enums/article_type.dart';

class WriteController extends GetxController {
  final title = ''.obs;
  final hasDeadline = false.obs;
  final selectedType = Rxn<ArticleType>();
  final body = ''.obs;
  final images = <XFile>[].obs;
  final mainImage = Rxn<XFile>();

  void selectPhotos() async {
    final result = await ImagePicker().pickMultiImage();
    images.addAll(result);
  }

  removeImage(int index) {
    if (images[index] == mainImage.value) {
      mainImage.value = null;
    }
    images.removeAt(index);
  }

  setMainImage(int index) {
    mainImage.value = images[index];
  }
}
