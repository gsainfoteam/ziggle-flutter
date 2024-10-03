import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/data/repositories/amplitude_analytics_repository.dart';
import 'package:ziggle/app/modules/core/data/repositories/firebase_analytics_repository.dart';
import 'package:ziggle/app/modules/core/data/repositories/smartlook_analytics_repository.dart';
import 'package:ziggle/app/modules/core/domain/enums/event_type.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';

@Singleton(as: AnalyticsRepository)
@prod
class MultipleAnalyticsRepository implements AnalyticsRepository {
  final FirebaseAnalyticsRepository _firebaseAnalyticsRepository;
  final AmplitudeAnalyticsRepository _amplitudeAnalyticsRepository;
  final SmartlookAnalyticsRepository _smartlookAnalyticsRepository;

  late final _repositories = [
    _firebaseAnalyticsRepository,
    _amplitudeAnalyticsRepository,
    _smartlookAnalyticsRepository,
  ];

  MultipleAnalyticsRepository(
    this._firebaseAnalyticsRepository,
    this._amplitudeAnalyticsRepository,
    this._smartlookAnalyticsRepository,
  );

  @override
  logChangeUser(UserEntity? user) {
    for (final repository in _repositories) {
      try {
        repository.logChangeUser(user);
      } catch (_) {}
    }
  }

  @override
  logEvent(EventType type, AnalyticsEvent event) {
    for (final repository in _repositories) {
      try {
        repository.logEvent(type, event);
      } catch (_) {}
    }
  }

  @override
  logScreen(String screenName) {
    for (final repository in _repositories) {
      try {
        repository.logScreen(screenName);
      } catch (_) {}
    }
  }
}
