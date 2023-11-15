import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/common/presentaion/widgets/article_card.dart';
import 'package:ziggle/app/common/presentaion/widgets/section_header.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/core/routes/routes.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_search_query_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_summary_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notices/notices_bloc.dart';

import '../../domain/enums/notice_type.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _blocs = Map.fromEntries(
      NoticeType.main.map((e) => MapEntry(e, sl<NoticesBloc>())));
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        _blocs.forEach((key, value) => value.add(
              NoticesEvent.fetch(NoticeSearchQueryEntity(
                limit: key.isHorizontal ? 10 : 4,
                orderBy: key.sort,
                tags: key.isSearchable ? [key.name] : null,
              )),
            ));
        await Future.wait(_blocs.entries.map(
          (e) => e.value.stream.firstWhere((event) => event.loaded),
        ));
      },
      child: _Layout(_blocs),
    );
  }
}

class _Layout extends StatelessWidget {
  final Map<NoticeType, NoticesBloc> _blocs;
  const _Layout(this._blocs);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: _blocs.entries
          .map(
            (e) => BlocBuilder<NoticesBloc, NoticesState>(
              bloc: e.value,
              builder: (context, state) => state.notices.isEmpty
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SectionHeader(
                            type: e.key,
                            onTap: () =>
                                context.push(Paths.articleSection(e.key)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildArticles(e.key, state.notices),
                        if (e.key.noPreview)
                          const SizedBox(height: 16)
                        else
                          const SizedBox(height: 30),
                      ],
                    ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildArticles(NoticeType type, List<NoticeSummaryEntity> notices) {
    if (type.noPreview) {
      return const SizedBox.shrink();
    }
    if (!type.isHorizontal) {
      return MasonryGridView.extent(
        maxCrossAxisExtent: 300,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        itemCount: notices.length,
        itemBuilder: (context, index) => NoticeCard(
          notice: notices[index],
          onTap: () => context.push(Paths.articleDetail, extra: notices[index]),
        ),
      );
    }
    return SizedBox(
      height: kNoticeCardHeight,
      child: LayoutBuilder(
        builder: (context, constraints) => PageView.builder(
          clipBehavior: Clip.none,
          controller: PageController(
            viewportFraction: 1 - (30 / constraints.maxWidth),
          ),
          allowImplicitScrolling: true,
          itemCount: notices.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: NoticeCard(
              notice: notices[index],
              direction: Axis.horizontal,
              onTap: () => context.push(
                Paths.articleDetail,
                extra: notices[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
