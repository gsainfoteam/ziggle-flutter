import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown/markdown.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_response.dart';
import 'package:ziggle/app/data/model/tag_response.dart';
import 'package:ziggle/app/data/model/write_store.dart';
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
  final loading = false.obs;
  late final String _userName;
  final _analyticsService = AnalyticsService.to;

  WriteStore get _writeData => WriteStore(
        title: titleController.text,
        body: bodyController.text,
        type: selectedType.value,
        deadline: hasDeadline.value ? deadline.value : null,
        imagePaths: images.map((e) => e.path),
        tags: _tags,
      );

  final WriteRepository _repository;

  late Timer _autoSaver;

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
    _autoSaver = Timer.periodic(const Duration(seconds: 5), _autoSave);

    final savedData = _repository.getSaved();
    if (savedData != null) {
      titleController.text = savedData.title;
      bodyController.text = savedData.body;
      selectedType.value = savedData.type;
      hasDeadline.value = savedData.deadline != null;
      deadline.value = savedData.deadline ?? DateTime.now();
      images.addAll(savedData.imagePaths.map((e) => XFile(e)));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (var tag in savedData.tags) {
          textFieldTagsController.addTag = tag;
        }
      });
    }
  }

  void _autoSave(timer) {
    _repository.save(_writeData);
  }

  @override
  void onClose() {
    _autoSaver.cancel();
    textFieldTagsController.dispose();
    super.onClose();
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
    loading.value = true;
    try {
      final result = await _repository.write(_writeData);

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
  }
}
