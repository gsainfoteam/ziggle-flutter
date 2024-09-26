import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/event_type.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';

abstract class AnalyticsRepository {
  logChangeUser(UserEntity? user);
  logScreen(String screenName);
  logEvent(EventType type, AnalyticsEvent event);
}
