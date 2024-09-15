import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class GroupManagementChangeBriefDescriptionPage extends StatelessWidget {
  const GroupManagementChangeBriefDescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: '그룹 관리',
        title: const Text('간단 소개 변경'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Assets.icons.editPencil.svg(),
                const SizedBox(width: 10),
                const Text('100/100'),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 161,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.symmetric(
                  horizontal: BorderSide(color: Palette.grayBorder),
                ),
              ),
              child: const TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            )
          ],
        ),
      ),
    );
  }
}
