import 'package:intl/intl.dart';

String DateFromatTransForm(DateTime now) {
  return DateFormat('yyyy-MM-dd a h:mm', 'ko_KR').format(now.toLocal());
}
