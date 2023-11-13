import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/app/data/model/article_response.dart';
import 'package:ziggle/app/data/services/analytics/service.dart';
import 'package:ziggle/app/data/services/user/service.dart';
import 'package:ziggle/app/modules/article/repository.dart';
import 'package:ziggle/gen/strings.g.dart';

class ArticleController extends GetxController {
  final article = Rxn<ArticleResponse>();
  final isReminder = false.obs;
  final scrollController = DraggableScrollableController();
  final scrollPixel = 0.0.obs;
  final pageController = PageController();
  final page = 1.obs;
  late final showReminderTooltip = _repository.shouldShowReminderTooltip.obs;
  final ArticleRepository _repository;
  final _analyticsService = AnalyticsService.to;
  final _userService = UserService.to;

  ArticleController(this._repository);

  @override
  void onClose() {
    scrollController.dispose();
    pageController.dispose();
    super.onClose();
  }

  Future<void> _load() async {
    final id = Get.parameters['id'];
    if (id == null) return;
    final intId = int.tryParse(id);
    if (intId == null) return;
    final data = await _repository.getArticleById(intId);
    article.value = data;
    isReminder.value = data.reminder;
    showReminderTooltip.value &=
        data.deadline != null && data.deadline!.isAfter(DateTime.now());
  }

  void onPageChanged(int page) {}

  onImageTap(int index) async {}

  void closeTooltip() {
    showReminderTooltip.value = false;
    _repository.hideReminderTooltip();
    _analyticsService.logHideReminderTooltip();
  }

  void toggleReminder() async {
    if ((await _userService.getUserInfo().first) == null) {
      _analyticsService.logTryReminder();
      Get.dialog(CupertinoAlertDialog(
        title: Text(t.article.reminderLogin.title),
        content: Text(t.article.reminderLogin.description),
        actions: [
          CupertinoDialogAction(
            child: Text(
              t.root.login,
              style: const TextStyle(color: Palette.black),
            ),
            onPressed: () {
              _userService.logout();
              _analyticsService.logLogoutAnonymous();
            },
          )
        ],
      ));
      return;
    }
    _analyticsService.logToggleReminder(isReminder.toggle().value);
    if (isReminder.value) {
      _repository.setReminder(article.value!.id);
    } else {
      _repository.cancelReminder(article.value!.id);
    }
  }

  void reportArticle() {
    _analyticsService.logTryReport();
    Get.dialog(CupertinoAlertDialog(
      title: Text(t.article.report.title),
      content: Text(t.article.report.description),
      actions: [
        CupertinoDialogAction(
          onPressed: Get.back,
          child: Text(
            t.article.report.no,
          ),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            _analyticsService.logReport();
            Get.back();
          },
          child: Text(t.article.report.yes),
        ),
      ],
    ));
  }
}
