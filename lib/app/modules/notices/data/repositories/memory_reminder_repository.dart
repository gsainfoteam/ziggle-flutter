import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/reminder_repository.dart';

@LazySingleton(as: ReminderRepository)
class MemoryReminderRepository implements ReminderRepository {
  bool _shouldShowReminderTooltip = true;

  @override
  Future<void> hideReminderTooltip() async {
    _shouldShowReminderTooltip = false;
  }

  @override
  bool get shouldShowReminderTooltip => _shouldShowReminderTooltip;
}
