import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/values/strings.dart';

class LoginController extends GetxController {
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
}
