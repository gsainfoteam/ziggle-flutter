import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/article_body.dart';

class NoticePreviewSheet extends StatelessWidget {
  final NoticeEntity notice;
  const NoticePreviewSheet({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.75,
      builder: (context, controller) => SingleChildScrollView(
        controller: controller,
        child: NoticeBody(notice: notice),
      ),
    );
  }
}
