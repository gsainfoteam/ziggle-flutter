import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_list_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/list_layout.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.title, required this.type});

  final String title;
  final NoticeType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.grayLight,
      appBar: ZiggleAppBar.compact(
        backLabel: t.notice.list,
        title: Text(title),
      ),
      body: BlocProvider(
        create: (_) => sl<NoticeListBloc>()..add(NoticeListEvent.load(type)),
        child: const ListLayout(),
      ),
    );
  }
}
