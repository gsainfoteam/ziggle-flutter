import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziggle/app/core/values/strings.dart';
import 'package:ziggle/app/data/services/user/service.dart';

class MyController extends GetxController {
  final _userService = UserService.to;
  final name = ''.obs;
  final studentId = ''.obs;
  final email = ''.obs;

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
}
