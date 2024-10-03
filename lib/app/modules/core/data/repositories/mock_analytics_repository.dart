import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/event_type.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';

@Singleton(as: AnalyticsRepository)
@dev
@test
class MockAnalyticsRepository implements AnalyticsRepository {
  @override
  logChangeUser(UserEntity? user) =>
      log('MockAnalyticsRepository.logChangeUser, user: $user');

  @override
  logEvent(EventType type, AnalyticsEvent event) => log(
        'MockAnalyticsRepository.logEvent, type: ${type.name}, event: ${event.name}, parameters: ${event.parameters}',
      );

  @override
  logScreen(String screenName) =>
      log('MockAnalyticsRepository.logScreen, screenName: $screenName');
}
