import 'package:amplitude_flutter/amplitude.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/event_type.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';
import 'package:ziggle/app/values/strings.dart';

@singleton
class AmplitudeAnalyticsRepository implements AnalyticsRepository {
  late final _instance = Amplitude.getInstance()..init(Strings.amplitudeApiKey);

  @override
  logChangeUser(UserEntity? user) {
    if (user == null) {
      _instance
        ..setUserId(null)
        ..clearUserProperties();
      return;
    }
    _instance
      ..setUserId(user.uuid)
      ..setUserProperties({
        'studentId': user.studentId,
        'email': user.email,
      });
  }

  @override
  logEvent(EventType type, AnalyticsEvent event) {
    _instance.logEvent(
      '${type.name}_${event.name}',
      eventProperties: event.parameters,
    );
  }

  @override
  logScreen(String screenName) {
    _instance.logEvent(
      'screen_view',
      eventProperties: {'screenName': screenName},
    );
  }
}
