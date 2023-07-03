import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/values/strings.dart';
import 'package:ziggle/app/data/services/user/service.dart';

class LoginController extends GetxController {
  final code = ''.obs;
  final _userService = UserService.to;
  final loading = false.obs;

  void login() async {
    try {
      final result = await FlutterWebAuth2.authenticate(
        url: idpUrl,
        callbackUrlScheme: 'https',
      );
      final uri = Uri.parse(result);
      final authCode = uri.queryParameters['auth_code'];
      Get.log('$authCode');
    } catch (_) {}
  }

  void loginWithCode() => _loginWithCode(code.value);

  void _loginWithCode(String code) async {
    if (code.length != 10) {
      Get.snackbar('Error', 'Code must be 10 characters long');
      return;
    }
    loading.value = true;
    try {
      await _userService.loginWithCode(code);
    } catch (_) {
      loading.value = false;
    }
  }
}
