import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';

@RoutePage()
class NoticeEditPage extends StatelessWidget {
  NoticeEditPage({super.key, int? id, NoticeEntity? notice})
      : assert(id != null || notice != null),
        id = id ?? notice!.id,
        notice = notice ?? NoticeEntity.fromId(id!);

  final int? id;
  final NoticeEntity? notice;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
