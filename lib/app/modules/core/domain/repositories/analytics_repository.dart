import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/event_type.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';

abstract class AnalyticsRepository {
  logChangeUser(UserEntity? user);
  logScreen(String screenName);
  logEvent(EventType type, AnalyticsEvent event);

  static AnalyticsRepository get _instance => sl<AnalyticsRepository>();

  static void click(AnalyticsEvent event) =>
      _instance.logEvent(EventType.click, event);
  static void pageView(AnalyticsEvent event) =>
      _instance.logEvent(EventType.pageview, event);
  static void view(AnalyticsEvent event) =>
      _instance.logEvent(EventType.view, event);
  static void action(AnalyticsEvent event) =>
      _instance.logEvent(EventType.action, event);
}
