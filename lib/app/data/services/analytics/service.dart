import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/data/services/user/service.dart';

class AnalyticsService {
  static AnalyticsService get to => Get.find();
  final UserService _userService;
  static final _instance = FirebaseAnalytics.instance;

  AnalyticsService(this._userService) {
    _userService.getUserInfo().listen((event) {
      _instance
        ..setUserId(id: event?.uuid)
        ..setUserProperty(name: 'studentId', value: event?.studentId)
        ..setUserProperty(name: 'email', value: event?.email);
    });
  }

  static NavigatorObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _instance);

  logTryLogin() => _instance.logEvent(name: 'try_login');
  logLoginCancel(String reason) =>
      _instance.logEvent(name: 'login_cancel', parameters: {'reason': reason});
  logLogin() => _instance.logLogin(loginMethod: 'IdP');
  logLoginAnonymous() => _instance.logLogin(loginMethod: 'anonymous');
  logLogout() => _instance.logEvent(name: 'logout');
  logLogoutAnonymous() => _instance.logEvent(name: 'logout_anonymous');
}
