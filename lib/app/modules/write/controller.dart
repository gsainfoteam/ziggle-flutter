import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown/markdown.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_response.dart';
import 'package:ziggle/app/modules/article/article_body.dart';

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

  showPreview() {
    Get.bottomSheet(
      DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.8,
        builder: (context, controller) => SingleChildScrollView(
          controller: controller,
          child: ArticleBody(
            article: ArticleResponse(
              id: 0,
              title: title.value,
              body: markdownToHtml(body.value),
              author: '엄준식',
              createdAt: DateTime.now(),
              views: 0,
            ),
          ),
        ),
      ),
      backgroundColor: Palette.white,
      isScrollControlled: true,
    );
  }

  submit() {}
}
