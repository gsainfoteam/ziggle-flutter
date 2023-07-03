import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown/markdown.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/core/values/strings.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_response.dart';
import 'package:ziggle/app/data/services/user/service.dart';
import 'package:ziggle/app/modules/write/article_preview_sheet.dart';
import 'package:ziggle/app/routes/pages.dart';

class WriteController extends GetxController {
  final titleController = TextEditingController();
  final hasDeadline = false.obs;
  final deadline = DateTime.now().obs;
  final selectedType = Rxn<ArticleType>();
  final textFieldTagsController = TextfieldTagsController();
  final _tags = <String>[];
  final bodyController = TextEditingController();
  final images = <XFile>[].obs;
  final mainImage = Rxn<XFile>();
  final loading = false.obs;
  late final String _userName;

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
    UserService.to
        .getUserInfo()
        .first
        .then((value) => _userName = value?.userName ?? placeholderUserName);
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
          title: titleController.text,
          body: markdownToHtml(bodyController.text),
          author: _userName,
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

  submit() async {
    if (titleController.text.isEmpty) {
      Get.snackbar('제목을 입력해주세요.', '제목을 입력하지 않으면 공지를 제출할 수 없습니다.');
      return;
    }
    if (selectedType.value == null) {
      Get.snackbar('공지 유형을 선택해주세요.', '공지 유형을 선택하지 않으면 공지를 제출할 수 없습니다.');
      return;
    }
    if (bodyController.text.isEmpty) {
      Get.snackbar('내용을 입력해주세요.', '내용을 입력하지 않으면 공지를 제출할 수 없습니다.');
      return;
    }
    if (images.isNotEmpty) {
      if (images.length == 1) {
        mainImage.value = images.first;
      }
      if (mainImage.value == null) {
        Get.snackbar('메인 이미지를 선택해주세요.', '메인 이미지를 선택하지 않으면 공지를 제출할 수 없습니다.');
        return;
      }
    }
    loading.value = true;
    try {
      await 1.seconds.delay();
      Get.toNamed(Routes.ARTICLE, parameters: {'id': '1'});
      await Get.defaultTransitionDuration.delay();
      _reset();
      loading.value = false;
    } catch (_) {
      loading.value = false;
    }
  }

  _reset() {
    titleController.clear();
    hasDeadline.value = false;
    deadline.value = DateTime.now();
    selectedType.value = null;
    textFieldTagsController.clearTags();
    bodyController.clear();
    images.clear();
    mainImage.value = null;
  }
}
