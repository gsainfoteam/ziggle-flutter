import 'package:intl/intl.dart';
import 'package:ziggle/gen/strings.g.dart';

String DateFromatTransForm(DateTime date, AppLocale locale) {
  final (intlLocale, pattern) = switch (locale) {
    AppLocale.ko => ('ko_KR', 'yyyy-MM-dd a h:mm'), // 2026-10-10 오후 3:20
    AppLocale.en => ('en_US', 'yyyy-MM-dd h:mm a'), // 2026-10-10 3:20 PM
    AppLocale.jp => ('ja_JP', 'yyyy-MM-dd HH:mm'), // 2026-10-10 15:20
    AppLocale.ru => ('ru_RU', 'dd.MM.yyyy HH:mm'), // 10-10-2026 15.20
  };
  return DateFormat(pattern, intlLocale).format(date.toLocal());
}
