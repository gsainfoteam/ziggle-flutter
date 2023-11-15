import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/common/presentaion/widgets/article_card.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/core/routes/routes.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/utils/extension/date_align.dart';
import 'package:ziggle/app/core/utils/functions/calculate_date_delta.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notices/notices_bloc.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_search_query_entity.dart';
import '../../domain/enums/notice_mine.dart';
import '../../domain/enums/notice_type.dart';

class _NoItemsFoundIndicator extends StatelessWidget {
  const _NoItemsFoundIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.images.noResult.image(width: 160),
        const SizedBox(height: 16),
        Text(t.search.noResult, style: TextStyles.secondaryLabelStyle),
      ],
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

class NoticeSectionPage extends StatelessWidget {
  final NoticeType type;
  const NoticeSectionPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<NoticesBloc>()),
      ],
      child: _Layout(type: type),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout({required this.type});

  final NoticeType type;

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final _scrollController = ScrollController();

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll - 200;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshIndicatorKey.currentState?.show();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<NoticesBloc>().add(const NoticesEvent.loadMore());
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.type.title)),
      body: RefreshIndicator.adaptive(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          final bloc = context.read<NoticesBloc>();
          bloc.add(NoticesEvent.fetch(
            NoticeSearchQueryEntity(
              tags: widget.type.isSearchable ? [widget.type.name] : null,
              orderBy: widget.type.sort,
              my: widget.type.mine,
            ),
          ));
          await bloc.stream.firstWhere((e) => e.loaded);
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Text(widget.type.emoji,
                      style: const TextStyle(fontSize: 140)),
                  Text(widget.type.title, style: TextStyles.articleTitleStyle),
                  Text(
                    widget.type.description,
                    textAlign: TextAlign.center,
                    style: TextStyles.articleCardAuthorStyle,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20) +
                  const EdgeInsets.only(bottom: 20),
              sliver: widget.type == NoticeType.deadline
                  ? _buildDeadlineList()
                  : _buildSimpleList(),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<NoticesBloc, NoticesState>(
                builder: (context, state) => !state.loaded
                    ? const _ProgressIndicator()
                    : state.notices.isEmpty
                        ? const _NoItemsFoundIndicator()
                        : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleList() {
    return BlocBuilder<NoticesBloc, NoticesState>(
      builder: (context, state) => SliverList.separated(
        itemCount: state.notices.length,
        separatorBuilder: (context, index) => const SizedBox(height: 18),
        itemBuilder: (context, index) => NoticeCard(
          notice: state.notices[index],
          direction: Axis.horizontal,
          onTap: () => context.push(
            Paths.articleDetail,
            extra: state.notices[index],
          ),
        ),
      ),
    );
  }

  Widget _buildDeadlineList() {
    return BlocBuilder<NoticesBloc, NoticesState>(
      builder: (context, state) {
        final groups = groupBy(
          state.notices,
          (notice) => notice.currentDeadline!.toLocal().aligned,
        ).entries.toList();
        return SliverList.separated(
          itemCount: groups.length,
          separatorBuilder: (context, index) => const SizedBox(height: 18),
          itemBuilder: (context, index) => Column(
            children: [
              Text(
                t.article.deadlineDelta(
                  n: calculateDateDelta(DateTime.now(), groups[index].key),
                ),
                style: TextStyles.articleCardTitleStyle,
              ),
              const SizedBox(height: 12),
              Container(width: 80, height: 1, color: Palette.black),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: groups[index]
                    .value
                    .map(
                      (notice) => Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: NoticeCard(
                          notice: notice,
                          direction: Axis.horizontal,
                          onTap: () =>
                              context.push(Paths.articleDetail, extra: notice),
                        ),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        );
      },
    );
  }
}
