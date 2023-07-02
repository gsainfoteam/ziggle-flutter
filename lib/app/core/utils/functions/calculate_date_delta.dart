/// b - a
int calculateDateDelta(DateTime a, DateTime b) => b
    .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0)
    .difference(a.copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0))
    .inDays;
