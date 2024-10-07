import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/event_type.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';

@lazySingleton
class SmartlookAnalyticsRepository implements AnalyticsRepository {
  final _instance = Smartlook.instance;

  @postConstruct
  void init() {
    _instance.start();
  }

  @override
  logChangeUser(UserEntity? user) {
    if (user == null) return;
    _instance.user
      ..setIdentifier(user.uuid)
      ..setEmail(user.email);
  }

  @override
  logEvent(EventType type, AnalyticsEvent event) {
    final properties = Properties();
    event.parameters.forEach((key, value) {
      properties.putString(key, value: value.toString());
    });
    _instance.trackEvent('${type.name}_${event.name}', properties: properties);
  }

  @override
  logScreen(String screenName) {
    _instance.trackNavigationEnter(screenName);
  }
}
