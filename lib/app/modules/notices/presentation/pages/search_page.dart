import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../bloc/notice_list_bloc.dart';
import '../widgets/infinite_scroll.dart';
import '../widgets/notice_list_item.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NoticeListBloc>(),
      child: const _Layout(),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    setState(() {});
    final bloc = context.read<NoticeListBloc>();
    if (_controller.text.isEmpty) {
      bloc.add(const NoticeListEvent.reset());
    } else {
      bloc.add(NoticeListEvent.load(query: _controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InfiniteScroll(
        onLoadMore: () => context
            .read<NoticeListBloc>()
            .add(const NoticeListEvent.loadMore()),
        slivers: [
          SliverAppBar(
            toolbarHeight: Theme.of(context).appBarTheme.toolbarHeight!,
            leadingWidth: Theme.of(context).appBarTheme.toolbarHeight!,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  suffixIcon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
                    child: _controller.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () => _controller.clear(),
                          ),
                  ),
                  hintText: t.notice.searchHint,
                  hintStyle: const TextStyle(color: Palette.textGreyDark),
                  fillColor: Palette.backgroundGreyLight,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Assets.icons.search.svg(
                      colorFilter: const ColorFilter.mode(
                        Palette.textGreyDark,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_controller.text.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.icons.search.svg(
                      width: 100,
                      height: 100,
                      colorFilter: const ColorFilter.mode(
                        Palette.textGreyDark,
                        BlendMode.srcIn,
                      ),
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.notice.searchHint,
                      style: const TextStyle(
                        color: Palette.textGrey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_controller.text.isNotEmpty)
            SliverSafeArea(
              top: false,
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
                          return NoticeListItem(
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
