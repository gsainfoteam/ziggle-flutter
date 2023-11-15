import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

@Injectable(as: AnalyticsRepository)
class MockAnalyticsRepository implements AnalyticsRepository {
  @override
  logScreen(String screenName) {
    debugPrint('Analytics: $screenName');
  }

  @override
  logOpenTermsOfService() {
    debugPrint('Analytics: open terms of service');
  }

  @override
  logLoginAnonymous() {
    debugPrint('Analytics: login anonymous');
  }

  @override
  logLogin() {
    debugPrint('Analytics: login');
  }

  @override
  logLoginCancel(String reason) {
    debugPrint('Analytics: login cancel $reason');
  }

  @override
  logTryLogin() {
    debugPrint('Analytics: try login');
  }

  @override
  logLogoutAnonymous() {
    debugPrint('Analytics: logout anonymous');
  }

  @override
  logLogout() {
    debugPrint('Analytics: logout');
  }

  @override
  logChangeImageCarousel(int page) {
    debugPrint('Analytics: change image carousel $page');
  }

  @override
  logHideReminderTooltip() {
    debugPrint('Analytics: hide reminder tooltip');
  }

  @override
  logToggleReminder(bool set) {
    debugPrint('Analytics: toggle reminder $set');
  }

  @override
  logTryReminder() {
    debugPrint('Analytics: try reminder');
  }

  @override
  logReport() {
    debugPrint('Analytics: report');
  }

  @override
  logTryReport() {
    debugPrint('Analytics: try report');
  }

  @override
  logOpenPrivacyPolicy() {
    debugPrint('Analytics: open privacy policy');
  }

  @override
  logOpenWithdrawal() {
    debugPrint('Analytics: open withdrawal');
  }

  @override
  logSearch(String value, Set<NoticeType> selectedType) {
    debugPrint('Analytics: search $value $selectedType');
  }

  @override
  logPreviewArticle() {
    debugPrint('Analytics: preview article');
  }

  @override
  logSubmitArticle() {
    debugPrint('Analytics: submit article');
  }

  @override
  logSubmitArticleCancel(String reason) {
    debugPrint('Analytics: submit article cancel $reason');
  }

  @override
  logTrySubmitArticle() {
    debugPrint('Analytics: try submit article');
  }
}
