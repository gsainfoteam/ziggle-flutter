import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/user_repository.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

@Singleton(as: AnalyticsRepository)
class ThirdAnalyticsRepository implements AnalyticsRepository {
  final UserRepository _userRepository;
  static final _analytics = FirebaseAnalytics.instance;
  static final _smartlook = Smartlook.instance;

  ThirdAnalyticsRepository(this._userRepository) {
    _userRepository.userInfo().listen((event) {
      _analytics
        ..setUserId(id: event?.id)
        ..setUserProperty(name: 'studentId', value: event?.studentId)
        ..setUserProperty(name: 'email', value: event?.email);
      if (event != null) {
        _smartlook.user
          ..setIdentifier(event.id)
          ..setEmail(event.email);
      }
    });
  }

  @override
  logScreen(String screenName) {
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

  @override
  logTryLogin() => _log('try_login');
  @override
  logLoginCancel(String reason) => _log('login_cancel', {'reason': reason});
  @override
  logLogin() => _log('login', {'method': 'IdP'});
  @override
  logLoginAnonymous() => _log('login', {'method': 'anonymous'});
  @override
  logLogout() => _log('logout');
  @override
  logLogoutAnonymous() => _log('logout_anonymous');

  @override
  logTryReminder() => _log('try_reminder');
  @override
  logToggleReminder(bool set) => _log('toggle_reminder', {'set': set ? 1 : 0});
  @override
  logHideReminderTooltip() => _log('hide_reminder_tooltip');
  @override
  logChangeImageCarousel(int page) =>
      _log('change_image_carousel', {'page': page});

  @override
  logSearch(String query, Iterable<NoticeType> types) => _log('search', {
        'query': query,
        'types': types.map((e) => e.name).join(', '),
      });

  @override
  logOpenPrivacyPolicy() => _log('open_privacy_policy');
  @override
  logOpenTermsOfService() => _log('open_terms_of_service');
  @override
  logOpenWithdrawal() => _log('open_withdrawal');

  @override
  logPreviewArticle() => _log('preview_article');
  @override
  logTrySelectImage() => _log('try_select_image');
  @override
  logSelectImage() => _log('select_image');
  @override
  logTrySubmitArticle() => _log('try_submit_article');
  @override
  logSubmitArticle() => _log('submit_article');
  @override
  logSubmitArticleCancel(String reason) =>
      _log('submit_article_cancel', {'reason': reason});
  @override
  logTryReport() => _log('try_report');
  @override
  logReport() => _log('report');
}
