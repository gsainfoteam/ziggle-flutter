import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown/markdown.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_response.dart';
import 'package:ziggle/app/data/model/tag_response.dart';
import 'package:ziggle/app/data/services/analytics/service.dart';
import 'package:ziggle/app/data/services/user/service.dart';
import 'package:ziggle/app/modules/write/article_preview_sheet.dart';
import 'package:ziggle/app/modules/write/repository.dart';
import 'package:ziggle/app/routes/pages.dart';
import 'package:ziggle/gen/strings.g.dart';

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
  final _analyticsService = AnalyticsService.to;

  final WriteRepository _repository;

  WriteController(this._repository);

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
    UserService.to.getUserInfo().first.then((value) => _userName = value!.name);
  }

  @override
  void onClose() {
    textFieldTagsController.dispose();
    super.onClose();
  }

  void selectPhotos() async {
    _analyticsService.logTrySelectImage();
    final result = await ImagePicker().pickMultiImage();
    images.addAll(result);
    _analyticsService.logSelectImage();
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
    _analyticsService.logPreviewArticle();
    Get.bottomSheet(
      ArticlePreviewSheet(
        article: ArticleResponse(
          id: 0,
          title: titleController.text,
          body: markdownToHtml(bodyController.text),
          author: _userName,
          createdAt: DateTime.now(),
          deadline: hasDeadline.value ? deadline.value : null,
          tags: _tags.map((e) => TagResponse(id: 0, name: e)).toList(),
          views: 0,
          reminder: false,
        ),
      ),
      backgroundColor: Palette.white,
      isScrollControlled: true,
    );
  }

  submit() async {
    _analyticsService.logTrySubmitArticle();
    if (titleController.text.isEmpty) {
      Get.snackbar(t.write.title.error.title, t.write.title.error.description);
      _analyticsService.logSubmitArticleCancel('empty title');
      return;
    }
    final type = selectedType.value;
    if (type == null) {
      Get.snackbar(t.write.type.error.title, t.write.type.error.description);
      _analyticsService.logSubmitArticleCancel('no type');
      return;
    }
    if (bodyController.text.isEmpty) {
      Get.snackbar(t.write.body.error.title, t.write.body.error.description);
      _analyticsService.logSubmitArticleCancel('empty body');
      return;
    }
    if (images.isNotEmpty) {
      if (images.length == 1) {
        mainImage.value = images.first;
      }
      if (mainImage.value == null) {
        Get.snackbar(
            t.write.images.error.title, t.write.images.error.description);
        _analyticsService.logSubmitArticleCancel('not select main image');
        return;
      }
    }
    loading.value = true;
    try {
      final imageKeys = await _repository.uploadImages(images);
      Get.log('$imageKeys');

      final result = await _repository.write(
        title: titleController.text,
        body: markdownToHtml(bodyController.text),
        type: type,
        deadline: hasDeadline.value ? deadline.value : null,
        tags: _tags,
        images: imageKeys,
      );

      Get.toNamed(Routes.ARTICLE, parameters: {'id': result.id.toString()});
      await Get.defaultTransitionDuration.delay();
      _reset();
      _analyticsService.logSubmitArticle();
    } catch (_) {
      _analyticsService.logSubmitArticleCancel('unknown error');
    } finally {
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
