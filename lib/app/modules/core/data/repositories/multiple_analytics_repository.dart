import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/data/repositories/firebase_analytics_repository.dart';
import 'package:ziggle/app/modules/core/domain/enums/event_type.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';

@Singleton(as: AnalyticsRepository)
@prod
class MultipleAnalyticsRepository implements AnalyticsRepository {
  final FirebaseAnalyticsRepository _firebaseAnalyticsRepository;
  late final _repositories = [
    _firebaseAnalyticsRepository,
  ];

  MultipleAnalyticsRepository(this._firebaseAnalyticsRepository);

  @override
  logChangeUser(UserEntity? user) {
    for (final repository in _repositories) {
      repository.logChangeUser(user);
    }
  }

  @override
  logEvent(EventType type, AnalyticsEvent event) {
    for (final repository in _repositories) {
      repository.logEvent(type, event);
    }
  }

  @override
  logScreen(String screenName) {
    for (final repository in _repositories) {
      repository.logScreen(screenName);
    }
  }
}
