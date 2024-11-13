import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';

@RoutePage()
class GroupManagementNotionPage extends StatelessWidget {
  const GroupManagementNotionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        from: PageSource.groupManagement,
        backLabel: '그룹 관리',
        title: Text('노션 링크 변경'),
      ),
    );
  }
}
