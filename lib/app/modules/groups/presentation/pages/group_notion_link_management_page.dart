import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';

class GroupNotionLinkManagementPage extends StatelessWidget {
  const GroupNotionLinkManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: '그룹 관리',
        title: const Text('노션 링크 변경'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        child: Column(
          children: [
            const ZiggleInput(hintText: 'https://example.notion.site'),
            const SizedBox(height: 30),
            ZiggleButton.cta(
              child: const Text('변경'),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
