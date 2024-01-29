import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/enums/notice_type.dart';
import '../bloc/notice_list_bloc.dart';
import '../widgets/infinite_scroll.dart';
import '../widgets/notice_card.dart';
import '../widgets/notice_list_item.dart';

class NoticeListPage extends StatelessWidget {
  const NoticeListPage({super.key, required this.type});

  final NoticeType type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<NoticeListBloc>()..add(NoticeListEvent.load(type: type)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(type.label),
          leadingWidth: Theme.of(context).appBarTheme.toolbarHeight!,
          actions: [
            IconButton(
              icon: Assets.icons.search.image(),
              onPressed: () => const SearchRoute().push(context),
            ),
            IconButton(
              icon: Assets.icons.editPencil.image(),
              onPressed: () {},
            ),
          ],
        ),
        body: const _Layout(),
      ),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  bool _isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.mediumImpact();
        final bloc = context.read<NoticeListBloc>()
          ..add(const NoticeListEvent.refresh());
        await bloc.stream.firstWhere((state) => state.loaded);
      },
      child: InfiniteScroll(
        onLoadMore: () => context.read<NoticeListBloc>()
          ..add(const NoticeListEvent.loadMore()),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5) +
                const EdgeInsets.only(left: 8),
            sliver: SliverToBoxAdapter(
              child: _LayoutSelector(
                isCollapsed: _isCollapsed,
                onChange: (v) => setState(() => _isCollapsed = v),
              ),
            ),
          ),
          SliverSafeArea(
            sliver: BlocBuilder<NoticeListBloc, NoticeListState>(
              builder: (context, state) => state.list.isEmpty
                  ? SliverPadding(
                      padding: const EdgeInsets.only(top: 8),
                      sliver: SliverToBoxAdapter(
                        child: Center(
                          child: state.loaded
                              ? Text(t.notice.noNotice)
                              : const CircularProgressIndicator(),
                        ),
                      ),
                    )
                  : SliverList.separated(
                      itemCount: state.list.length + (state.loaded ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index == state.list.length) {
                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final notice = state.list[index];
                        onTapDetail() =>
                            NoticeRoute.fromEntity(notice).push(context);
                        return _isCollapsed
                            ? NoticeListItem(
                                notice: notice,
                                onTapDetail: onTapDetail,
                              )
                            : NoticeCard(
                                notice: notice,
                                onTapDetail: onTapDetail,
                              );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LayoutSelector extends StatelessWidget {
  const _LayoutSelector({required this.isCollapsed, required this.onChange});

  final bool isCollapsed;
  final void Function(bool) onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          t.notice.layout.label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 10),
        Text(
          isCollapsed ? t.notice.layout.collapsed : t.notice.layout.large,
          style: const TextStyle(color: Palette.textGrey),
        ),
        const Spacer(),
        Container(
          decoration: const BoxDecoration(
            color: Palette.background200,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Stack(
            fit: StackFit.loose,
            children: [
              Positioned.fill(
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  alignment: isCollapsed
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Palette.black,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onChange(true),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3.5,
                        ),
                        child: Assets.icons.tableRows.image(
                          width: 24,
                          color: isCollapsed ? Palette.background100 : null,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onChange(false),
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3.5,
                        ),
                        child: Assets.icons.layoutSquare.image(
                          width: 24,
                          color: isCollapsed ? null : Palette.background100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
