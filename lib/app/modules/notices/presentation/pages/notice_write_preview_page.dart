import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_back_button.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeWritePreviewPage extends StatelessWidget {
  const NoticeWritePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar(
        leading: ZiggleBackButton(label: context.t.notice.write.configTitle),
        title: Text(context.t.notice.write.preview),
      ),
    );
  }
}
