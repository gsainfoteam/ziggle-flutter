import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/event_type.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';

abstract class AnalyticsRepository {
  logChangeUser(UserEntity? user);
  logScreen(String screenName);
  logEvent(EventType type, AnalyticsEvent event);

  static void click(AnalyticsEvent event) =>
      sl<AnalyticsRepository>().logEvent(EventType.click, event);
  static void pageView(AnalyticsEvent event) =>
      sl<AnalyticsRepository>().logEvent(EventType.pageview, event);
  static void view(AnalyticsEvent event) =>
      sl<AnalyticsRepository>().logEvent(EventType.view, event);
  static void action(AnalyticsEvent event) =>
      sl<AnalyticsRepository>().logEvent(EventType.action, event);
}
