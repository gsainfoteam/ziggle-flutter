import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class WriteController extends GetxController {
  final images = <XFile>[].obs;

  void selectPhotos() async {
    final result = await ImagePicker().pickMultiImage();
    images.addAll(result);
  }

  removeImage(int index) {
    images.removeAt(index);
  }
}
