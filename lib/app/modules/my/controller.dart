import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziggle/app/core/values/strings.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/services/user/service.dart';
import 'package:ziggle/app/modules/my/repository.dart';
import 'package:ziggle/app/routes/pages.dart';

class MyController extends GetxController {
  final _userService = UserService.to;
  final name = ''.obs;
  final studentId = ''.obs;
  final email = ''.obs;
  final MyRepository _repository;
  final articles = Rxn<ProfileArticleData>();

  MyController(this._repository);

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  _load() async {
    final user = await _userService.getUserInfo().first;
    if (user == null) {
      return;
    }

    name.value = user.userName;
    studentId.value = user.studentId;
    email.value = user.userEmailId;
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
}
