import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziggle/app/core/values/strings.dart';
// import 'package:ziggle/app/data/provider/api_channel.dart';
import 'package:ziggle/app/data/services/analytics/service.dart';
import 'package:ziggle/app/data/services/user/service.dart';

class LoginController extends GetxController {
  final code = ''.obs;
  final _userService = UserService.to;
  final _analyticsService = AnalyticsService.to;
  // final _apiChannelProvider = ApiChannelProvider.to;
  final loading = false.obs;

  void login() async {
    _analyticsService.logTryLogin();
    try {
      final result = await FlutterWebAuth2.authenticate(
        url: '',
        // url: '${_apiChannelProvider.channel.idpBaseUrl}'
        //     '${_userService.recentLogout ? reloginIdpPath : idpPath}',
        callbackUrlScheme: idpRedirectScheme,
      );
      final uri = Uri.parse(result);
      final authCode = uri.queryParameters['code'];
      if (authCode == null) {
        Get.snackbar('Error', 'Failed to get auth code');
        _analyticsService.logLoginCancel('no code');
        return;
      }
      _loginWithCode(authCode);
    } on PlatformException catch (e) {
      _analyticsService.logLoginCancel(e.code);
    } catch (_) {
      _analyticsService.logLoginCancel('error while authentication');
    }
  }

  void _loginWithCode(String code) async {
    loading.value = true;
    try {
      await _userService.loginWithCode(code);
      _analyticsService.logLogin();
    } catch (_) {
      loading.value = false;
      _analyticsService.logLoginCancel('error while login');
    }
  }

  void skipLogin() {
    _userService.skipLogin();
    _analyticsService.logLoginAnonymous();
  }

  void openTerms() {
    _analyticsService.logOpenTermsOfService();
    launchUrl(Uri.parse(termsOfServiceUrl));
  }

  void openHidden() async {
    final text = TextEditingController();
    await Get.dialog(
      CupertinoAlertDialog(
        title: const Text('enter password'),
        content: CupertinoTextField(controller: text),
      ),
    );
    final password = text.text;
    text.dispose();
    final bytes = utf8.encode(password);
    final digest = sha1.convert(bytes).toString();
    if (digest != 'bf782aa0b57c80e2b10b2f195327a32f60e250af') return;
    // final channel = ApiChannelProvider.to.toggleChannel();
    // Get.showSnackbar(GetSnackBar(
    //   message: 'current using ${channel.baseUrl}',
    //   duration: const Duration(seconds: 2),
    // ));
  }
}
