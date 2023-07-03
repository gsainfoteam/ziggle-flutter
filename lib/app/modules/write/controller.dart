import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown/markdown.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_response.dart';
import 'package:ziggle/app/modules/write/article_preview_sheet.dart';

class WriteController extends GetxController {
  final title = ''.obs;
  final hasDeadline = false.obs;
  final deadline = DateTime.now().obs;
  final selectedType = Rxn<ArticleType>();
  final textFieldTagsController = TextfieldTagsController();
  final _tags = <String>[];
  final body = ''.obs;
  final images = <XFile>[].obs;
  final mainImage = Rxn<XFile>();

  @override
  void onInit() {
    super.onInit();
    textFieldTagsController.addListener(() {
      final tags = textFieldTagsController.getTags ?? [];
      _tags.clear();
      for (final tag in tags) {
        if (_tags.contains(tag)) {
          textFieldTagsController.removeTag = tag;
        } else {
          _tags.add(tag);
        }
      }
    });
  }

  @override
  void onClose() {
    textFieldTagsController.dispose();
    super.onClose();
  }

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

  showPreview() {
    Get.bottomSheet(
      ArticlePreviewSheet(
        article: ArticleResponse(
          id: 0,
          title: title.value,
          body: markdownToHtml(body.value),
          author: '엄준식',
          createdAt: DateTime.now(),
          deadline: hasDeadline.value ? deadline.value : null,
          tags: _tags,
          views: 0,
        ),
      ),
      backgroundColor: Palette.white,
      isScrollControlled: true,
    );
  }

  submit() {}
}
