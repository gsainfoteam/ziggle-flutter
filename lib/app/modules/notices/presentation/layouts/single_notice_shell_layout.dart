import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/gen/assets.gen.dart';

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
      child: BlocListener<NoticeBloc, NoticeState>(
        listener: (context, state) => state.mapOrNull(
          error: (error) => context.showToast(error.message),
        ),
        child: BlocBuilder<NoticeBloc, NoticeState>(builder: (context, state) {
          if (state.entity == null) {
            return Center(
                child: Lottie.asset(Assets.lotties.loading,
                    height: MediaQuery.of(context).size.width * 0.2,
                    width: MediaQuery.of(context).size.width * 0.2));
          }
          return const AutoRouter();
        }),
      ),
    );
  }
}
