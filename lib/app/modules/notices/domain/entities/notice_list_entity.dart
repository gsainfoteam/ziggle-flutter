import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';

class NoticeListEntity {
  final int total;
  final List<NoticeEntity> list;

  NoticeListEntity({required this.total, required this.list});
}
