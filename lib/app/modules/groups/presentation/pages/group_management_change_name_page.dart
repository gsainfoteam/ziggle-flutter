import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/values/palette.dart';

@RoutePage()
class GroupManagementChangeNamePage extends StatelessWidget {
  const GroupManagementChangeNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        from: PageSource.setting,
        backLabel: '그룹 관리',
        title: const Text('그룹명 변경'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  '그룹명',
                  style: TextStyle(fontSize: 16, color: Palette.black),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const ZiggleInput(hintText: '현재 그룹 이름'),
            const SizedBox(height: 30),
            ZiggleButton.cta(
              child: const Text('변경'),
            )
          ],
        ),
      ),
    );
  }
}
