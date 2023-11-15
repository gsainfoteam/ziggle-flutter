abstract class ReminderRepository {
  bool get shouldShowReminderTooltip;
  Future<void> hideReminderTooltip();
}
