import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_row_button.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';

class GroupManagementPage extends StatelessWidget {
  const GroupManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: '그룹 관리',
        title: const Text('그룹 관리'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 25,
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    '그룹 이름',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Palette.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    color: Colors.green,
                  )
                ],
              ),
              const SizedBox(
                height: 27,
              ),
              ZiggleButton.cta(
                emphasize: false,
                width: null,
                child: const Text(
                  '그룹 프로필 사진 변경',
                  style: TextStyle(
                    color: Palette.black,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              ZiggleRowButton(
                title: const Text('그룹명 변경'),
                onPressed: () => GroupManagementNameRoute().go(context),
              ),
              const SizedBox(height: 20),
              ZiggleRowButton(
                title: const Text('그룹 간단 소개 변경'),
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              ZiggleRowButton(
                title: const Text('노션 페이지 링크 변경'),
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              ZiggleRowButton(
                title: const Text('초대 링크 생성'),
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              ZiggleRowButton(
                title: const Text('멤버 관리'),
                onPressed: () {},
              ),
              const SizedBox(height: 40),
              ZiggleRowButton(
                title: const Text(
                  '그룹 삭제',
                  style: TextStyle(
                    color: Palette.primary,
                  ),
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              ZiggleRowButton(
                title: const Text(
                  '그룹 나가기',
                  style: TextStyle(
                    color: Palette.primary,
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
