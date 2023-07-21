import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziggle/app/core/values/strings.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/data/services/user/service.dart';
import 'package:ziggle/app/modules/profile/repository.dart';
import 'package:ziggle/app/routes/pages.dart';

class ProfileController extends GetxController {
  final _userService = UserService.to;
  final name = ''.obs;
  final studentId = ''.obs;
  final email = ''.obs;
  final ProfileRepository _repository;
  final articles = Rxn<Map<ArticleType, ProfileArticleData>>();
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
  }

  void goToPrivacyPolicy() {
    launchUrl(Uri.parse(privacyPolicyUrl));
  }

  void goToTermsOfService() {
    launchUrl(Uri.parse(termsOfServiceUrl));
  }

  goToList(ArticleType e) {
    Get.toNamed(Routes.ARTICLE_SECTION, parameters: {'type': e.name});
  }

  goToDetail(ArticleSummaryResponse article) {
    Get.toNamed(Routes.ARTICLE, parameters: {'id': article.id.toString()});
  }
}
