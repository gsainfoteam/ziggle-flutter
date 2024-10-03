import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/event_type.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';

@Singleton(as: AnalyticsRepository)
@prod
class MultipleAnalyticsRepository implements AnalyticsRepository {
  @override
  logChangeUser(UserEntity? user) {
    // TODO: implement logChangeUser
    throw UnimplementedError();
  }

  @override
  logEvent(EventType type, AnalyticsEvent event) {
    // TODO: implement logEvent
    throw UnimplementedError();
  }

  @override
  logScreen(String screenName) {
    // TODO: implement logScreen
    throw UnimplementedError();
  }
}
