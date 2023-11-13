import 'notice_summary_entity.dart';

class NoticeListEntity {
  final List<NoticeSummaryEntity> list;
  final int total;

  NoticeListEntity({
    required this.list,
    required this.total,
  });
}
