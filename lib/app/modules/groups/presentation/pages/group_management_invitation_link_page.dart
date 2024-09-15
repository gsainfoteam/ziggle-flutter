import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_select.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class GroupManagementInvitatoinLinkPage extends StatelessWidget {
  const GroupManagementInvitatoinLinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: '그룹 관리',
        title: const Text('초대 링크 생성'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          children: [
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Palette.grayLight,
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Assets.icons.link.svg(),
                      const SizedBox(width: 6),
                      const Text('초대 링크'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ZiggleSelect(
                    hintText: '만료 기간 선택',
                    entries: [
                      ZiggleSelectEntry(label: '1일', value: '1일'),
                      ZiggleSelectEntry(label: '3일', value: '3일'),
                      ZiggleSelectEntry(label: '1주일', value: '1주일'),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            ZiggleButton.cta(
              child: const Text(
                '돌아가기',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
