import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_list_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/list_layout.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.type});

  final NoticeType type;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>
    with AutoRouteAwareStateMixin<ListPage> {
  @override
  void didPush() =>
      AnalyticsRepository.pageView(AnalyticsEvent.list(widget.type));
  @override
  void didPopNext() =>
      AnalyticsRepository.pageView(AnalyticsEvent.list(widget.type));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.grayLight,
      appBar: ZiggleAppBar.compact(
        backLabel: context.t.notice.list,
        title: Text(widget.type.getName(context)),
      ),
      body: BlocProvider(
        create: (_) =>
            sl<NoticeListBloc>()..add(NoticeListEvent.load(widget.type)),
        child: ListLayout(
          noticeType: widget.type,
        ),
      ),
    );
  }
}
