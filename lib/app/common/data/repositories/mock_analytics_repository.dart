import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';

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
}
