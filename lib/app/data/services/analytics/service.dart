import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/services/user/service.dart';

class AnalyticsService {
  static AnalyticsService get to => Get.find();
  final UserService _userService;
  static final _analytics = FirebaseAnalytics.instance;
  static final _smartlook = Smartlook.instance;

  AnalyticsService(this._userService) {
    _userService.getUserInfo().listen((event) {
      _analytics
        ..setUserId(id: event?.uuid)
        ..setUserProperty(name: 'studentId', value: event?.studentId)
        ..setUserProperty(name: 'email', value: event?.email);
      if (event != null) {
        _smartlook.user
          ..setIdentifier(event.uuid)
          ..setEmail(event.email);
      }
    });
  }

  static List<NavigatorObserver> get observers => [
        FirebaseAnalyticsObserver(
            analytics: _analytics, nameExtractor: (_) => Get.currentRoute),
        SmartlookObserver(),
      ];

  logChangePage(String screenName) {
    _analytics.setCurrentScreen(screenName: screenName);
    _smartlook.trackNavigationEnter(screenName);
  }

  _log(String name, [Map<String, dynamic>? parameters]) {
    _analytics.logEvent(name: name, parameters: parameters);
    final properties = Properties();
    parameters?.forEach((key, value) {
      properties.putString(key, value: value.toString());
    });
    _smartlook.trackEvent(name, properties: properties);
  }

  logTryLogin() => _log('try_login');
  logLoginCancel(String reason) => _log('login_cancel', {'reason': reason});
  logLogin() => _log('login', {'method': 'IdP'});
  logLoginAnonymous() => _log('login', {'method': 'anonymous'});
  logLogout() => _log('logout');
  logLogoutAnonymous() => _log('logout_anonymous');

  logTryReminder() => _log('try_reminder');
  logToggleReminder(bool set) => _log('toggle_reminder', {'set': set ? 1 : 0});
  logHideReminderTooltip() => _log('hide_reminder_tooltip');
  logChangeImageCarousel(int page) =>
      _log('change_image_carousel', {'page': page});

  logSearch(String query, Iterable<ArticleType> types) => _log('search', {
        'query': query,
        'types': types.map((e) => e.name).join(', '),
      });

  logOpenPrivacyPolicy() => _log('open_privacy_policy');
  logOpenTermsOfService() => _log('open_terms_of_service');
  logOpenWithdrawal() => _log('open_withdrawal');

  logPreviewArticle() => _log('preview_article');
  logTrySelectImage() => _log('try_select_image');
  logSelectImage() => _log('select_image');
  logTrySubmitArticle() => _log('try_submit_article');
  logSubmitArticle() => _log('submit_article');
  logSubmitArticleCancel(String reason) =>
      _log('submit_article_cancel', {'reason': reason});
  logTryReport() => _log('try_report');
  logReport() => _log('report');
}
