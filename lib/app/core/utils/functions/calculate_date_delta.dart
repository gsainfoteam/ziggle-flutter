import 'package:ziggle/app/core/utils/extension/date_align.dart';

/// b - a
int calculateDateDelta(DateTime a, DateTime b) =>
    b.aligned.difference(a.aligned).inDays;
