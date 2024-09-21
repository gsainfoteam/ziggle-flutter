import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/fonts.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupManagementMainPage extends StatelessWidget {
  const GroupManagementMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: context.t.group.managementMain.back,
        title: Text(context.t.group.managementMain.header),
        actions: [
          GestureDetector(
            child: Text(
              context.t.group.managementMain.newGroup,
              style: const TextStyle(
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
              context.t.group.managementMain.myGroup,
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
                    Text(
                      context.t.group.managementMain.noGroup,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: Text(
                        context.t.group.managementMain.contact,
                        style: const TextStyle(
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
