import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/notice_renderer.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with AutoRouteAwareStateMixin<DetailPage> {
  @override
  void didPush() async {
    final notice = await context
        .read<NoticeBloc>()
        .stream
        .firstWhere((s) => s.entity != null);
    AnalyticsRepository.pageView(AnalyticsEvent.notice(notice.entity!.id));
  }

  @override
  void didPopNext() => AnalyticsRepository.pageView(AnalyticsEvent.notice(
        context.read<NoticeBloc>().state.entity!.id,
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: context.t.notice.detail.back,
        from: PageSource.detail,
        title: Text(context.t.notice.detail.title),
      ),
      body: const _Layout(),
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
