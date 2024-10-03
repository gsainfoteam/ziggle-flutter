import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';

@RoutePage()
class SingleNoticeShellLayout extends StatelessWidget {
  SingleNoticeShellLayout({
    super.key,
    @PathParam() int? id,
    NoticeEntity? notice,
  })  : assert(id != null || notice != null),
        id = id ?? notice!.id,
        notice = notice ?? NoticeEntity.fromId(id!);
  final int id;
  final NoticeEntity notice;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NoticeBloc>()..add(NoticeEvent.load(notice)),
      child: BlocBuilder<NoticeBloc, NoticeState>(builder: (context, state) {
        if (state.entity == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return const AutoRouter();
      }),
    );
  }
}
