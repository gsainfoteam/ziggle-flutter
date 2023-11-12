import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';

@Injectable(as: AnalyticsRepository)
class MockAnalyticsRepository implements AnalyticsRepository {
  @override
  logScreen(String screenName) {
    debugPrint('Analytics: $screenName');
  }
}
