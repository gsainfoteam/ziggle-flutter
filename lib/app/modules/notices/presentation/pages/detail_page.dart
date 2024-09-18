import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/notice_renderer.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.notice});
  final NoticeEntity notice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: context.t.notice.detail.back,
        title: Text(context.t.notice.detail.title),
      ),
      body: BlocProvider(
        create: (_) => sl<NoticeBloc>()..add(NoticeEvent.load(notice)),
        child: const _Layout(),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    final notice = context.select((NoticeBloc bloc) => bloc.state.entity);
    if (notice == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return NoticeRenderer(notice: notice);
  }
}
