import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';

class GroupMemberManagementPage extends StatelessWidget {
  const GroupMemberManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: '그룹 관리',
        title: const Text('멤버 관리'),
      ),
    );
  }
}
