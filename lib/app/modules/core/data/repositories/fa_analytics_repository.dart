import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/event_type.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';

import '../../domain/repositories/analytics_repository.dart';

@Singleton(as: AnalyticsRepository)
@prod
class FirebaseAnalyticsRepository implements AnalyticsRepository {
  static final _analytics = FirebaseAnalytics.instance;

  @override
  logChangeUser(UserEntity? user) {
    _analytics
      ..setUserId(id: user?.uuid)
      ..setUserProperty(name: 'studentId', value: user?.studentId)
      ..setUserProperty(name: 'email', value: user?.email);
  }

  @override
  logScreen(String screenName) {
    _analytics.logScreenView(screenName: screenName);
  }

  @override
  logEvent(EventType type, AnalyticsEvent event) {
    _analytics.logEvent(
        name: '${type.name}_${event.name}', parameters: event.parameters);
  }
}
