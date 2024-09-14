import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/fonts.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class GroupManagementMainPage extends StatelessWidget {
  const GroupManagementMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: t.group.groupManagementMain.back,
        title: Text(t.group.groupManagementMain.header),
        actions: [
          GestureDetector(
            child: const Text(
              '새 그룹',
              style: TextStyle(
                fontSize: 16,
                color: Palette.primary,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 25, 16, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.group.groupManagementMain.myGroup,
              style: const TextStyle(
                fontSize: 28,
                fontFamily: FontFamily.tossFace,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Assets.images.noGroup.svg(),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '속한 그룹이 없습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Palette.grayText,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 361,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: ShapeDecoration(
                color: const Color(0xFFF7F7F7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: Text(
                        '특정 그룹에 속하길 바라신다면, 해당 그룹의 관리자에게 문의해주세요.',
                        style: TextStyle(
                          color: Color(0xFF6E6E73),
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
