import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziggle/app/core/routes/routes.dart';
import 'package:ziggle/app/core/values/strings.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/data/services/analytics/service.dart';
import 'package:ziggle/app/data/services/user/service.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/profile/repository.dart';

class ProfileController extends GetxController {
  final _userService = UserService.to;
  final _analyticsService = AnalyticsService.to;
  final name = ''.obs;
  final studentId = ''.obs;
  final email = ''.obs;
  final ProfileRepository _repository;
  final articles = Rxn<Map<NoticeType, ProfileArticleData>>();
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  ProfileController(this._repository);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshIndicatorKey.currentState?.show();
    });
  }

  Future<void> load() async {
    final user = await _userService.getUserInfo().first;
    if (user == null) {
      return;
    }

    name.value = user.name;
    studentId.value = user.studentId;
    email.value = user.email;
    _repository.getArticles().then((value) => articles.value = value);
  }

  void logout() {
    _userService.logout();
    _analyticsService.logLogout();
  }

  void goToPrivacyPolicy() {
    launchUrl(Uri.parse(privacyPolicyUrl));
    _analyticsService.logOpenPrivacyPolicy();
  }

  void goToTermsOfService() {
    launchUrl(Uri.parse(termsOfServiceUrl));
    _analyticsService.logOpenTermsOfService();
  }

  void goToWithdrawal() {
    launchUrl(Uri.parse(withdrawalUrl));
    _analyticsService.logOpenWithdrawal();
  }

  goToList(NoticeType e) {
    Get.toNamed(Paths.articleSection, parameters: {'type': e.name});
  }

  goToDetail(ArticleSummaryResponse article) {
    Get.toNamed(Paths.article, parameters: {'id': article.id.toString()});
  }
}
