import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_back_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeWriteBodyPage extends StatelessWidget {
  const NoticeWriteBodyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar(
        leading: ZiggleBackButton(label: t.common.cancel),
        title: Text(t.notice.write.title),
        actions: [
          ZiggleButton(
            type: ZiggleButtonType.text,
            child: Text(
              t.common.done,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
