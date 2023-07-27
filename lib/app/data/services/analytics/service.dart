import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
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

  static NavigatorObserver get observer => FirebaseAnalyticsObserver(
      analytics: _instance, nameExtractor: (_) => Get.currentRoute);

  logChangePage(String screenName) =>
      _instance.setCurrentScreen(screenName: screenName);

  logTryLogin() => _instance.logEvent(name: 'try_login');
  logLoginCancel(String reason) =>
      _instance.logEvent(name: 'login_cancel', parameters: {'reason': reason});
  logLogin() => _instance.logLogin(loginMethod: 'IdP');
  logLoginAnonymous() => _instance.logLogin(loginMethod: 'anonymous');
  logLogout() => _instance.logEvent(name: 'logout');
  logLogoutAnonymous() => _instance.logEvent(name: 'logout_anonymous');

  logTryReminder() => _instance.logEvent(name: 'try_reminder');
  logToggleReminder(bool set) => _instance
      .logEvent(name: 'toggle_reminder', parameters: {'set': set ? 1 : 0});
  logHideReminderTooltip() => _instance.logEvent(name: 'hide_reminder_tooltip');
  logChangeImageCarousel(int page) => _instance
      .logEvent(name: 'change_image_carousel', parameters: {'page': page});

  logSearch(String query, Iterable<ArticleType> types) =>
      _instance.logEvent(name: 'search', parameters: {
        'query': query,
        'types': types.map((e) => e.name).join(', '),
      });

  logOpenPrivacyPolicy() => _instance.logEvent(name: 'open_privacy_policy');
  logOpenTermsOfService() => _instance.logEvent(name: 'open_terms_of_service');
  logOpenWithdrawal() => _instance.logEvent(name: 'open_withdrawal');

  logPreviewArticle() => _instance.logEvent(name: 'preview_article');
  logTrySelectImage() => _instance.logEvent(name: 'try_select_image');
  logSelectImage() => _instance.logEvent(name: 'select_image');
  logTrySubmitArticle() => _instance.logEvent(name: 'try_submit_article');
  logSubmitArticle() => _instance.logEvent(name: 'submit_article');
  logSubmitArticleCancel(String reason) => _instance
      .logEvent(name: 'submit_article_cancel', parameters: {'reason': reason});
  logTryReport() => _instance.logEvent(name: 'try_report');
  logReport() => _instance.logEvent(name: 'report');
}
