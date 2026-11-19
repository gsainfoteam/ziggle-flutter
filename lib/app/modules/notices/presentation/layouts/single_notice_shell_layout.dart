import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/route_entrance.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/app/values/palette.dart';
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
      // Start loaded with the notice we were given, so the detail page is in
      // place from the first frame of the route transition. Starting empty
      // showed a bare loader for a frame and then built the whole page (and
      // its WebView) mid-transition, which made the page stutter in on iOS
      // and pop in without a transition on Android.
      create: (_) => NoticeBloc(sl(), sl(), initial: notice)
        ..add(NoticeEvent.load(notice)),
      child: BlocListener<NoticeBloc, NoticeState>(
        listener: (context, state) => state.mapOrNull(
          error: (error) => context.showToast(error.message),
        ),
        child: BlocBuilder<NoticeBloc, NoticeState>(builder: (context, state) {
          if (state.entity == null) {
            // The route has no Scaffold of its own; paint the page background
            // so the loader never shows the previous page through it.
            return ColoredBox(
              color: Palette.white,
              child: Center(
                  child: Lottie.asset(Assets.lotties.loading,
                      height: MediaQuery.of(context).size.width * 0.2,
                      width: MediaQuery.of(context).size.width * 0.2)),
            );
          }
          // The detail page lives in a nested navigator whose own route never
          // animates; expose this route's transition to it.
          return RouteEntrance(
            animation: ModalRoute.of(context)?.animation,
            child: const AutoRouter(),
          );
        }),
      ),
    );
  }
}
