import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ziggle/app/common/presentaion/widgets/label.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeTranslationPage extends StatelessWidget {
  final NoticeEntity notice;
  const NoticeTranslationPage({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.article.settings.writeTranslation),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Label(icon: Icons.menu, label: '한글 본문'),
            SelectionArea(
              child: Html(
                data: notice.contents.first.body,
                style: {'body': Style(margin: Margins.zero)},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
