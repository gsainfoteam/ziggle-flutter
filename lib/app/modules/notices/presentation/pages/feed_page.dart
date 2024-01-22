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
import '../widgets/notice_card.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<NoticeListBloc>()..add(const NoticeListEvent.load()),
        ),
      ],
      child: const _Layout(),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    final mediaQueryPadding = MediaQuery.paddingOf(context);
    final toolbarHeight = Theme.of(context).appBarTheme.toolbarHeight!;
    final bottomHeight = toolbarHeight + 8;

    return Scaffold(
      body: RefreshIndicator(
        edgeOffset: mediaQueryPadding.top + toolbarHeight + bottomHeight,
        onRefresh: () async {
          HapticFeedback.mediumImpact();
          final bloc = context.read<NoticeListBloc>()
            ..add(const NoticeListEvent.refresh());
          await bloc.stream.firstWhere((state) => state.loaded);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: toolbarHeight,
              floating: true,
              leading: Center(
                child: Assets.logo.black.image(height: toolbarHeight),
              ),
              actions: [
                IconButton(
                  icon: Assets.icons.search.image(),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Assets.icons.editPencil.image(),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Assets.icons.user.image(),
                  onPressed: () => const MyPageRoute().push(context),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(bottomHeight),
                child: _buildNoticeTypeChips(),
              ),
            ),
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
                        itemCount: state.list.length,
                        itemBuilder: (context, index) {
                          final notice = state.list[index];
                          return NoticeCard(
                            notice: notice,
                            onTapDetail: () =>
                                NoticeRoute.fromEntity(notice).push(context),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeTypeChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: BlocBuilder<NoticeListBloc, NoticeListState>(
          builder: (context, state) => Wrap(
            spacing: 8,
            children: NoticeType.sections
                .map(
                  (e) => ActionChip.elevated(
                    labelPadding: const EdgeInsets.only(right: 8),
                    avatar: e.icon.image(
                      width: 16,
                      color: e == state.type ? Palette.background100 : null,
                    ),
                    label: Row(
                      children: [
                        Text(e.label),
                        ClipRect(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            alignment: Alignment.centerLeft,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: SizedBox(
                                width: e != state.type ? 0 : null,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 16,
                                    color: e == state.type
                                        ? Palette.background100
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      if (e == state.type) {
                        SectionRoute(type: e).push(context);
                        return;
                      }
                      context
                          .read<NoticeListBloc>()
                          .add(NoticeListEvent.load(e));
                    },
                    labelStyle: TextStyle(
                      color: e == state.type ? Palette.background100 : null,
                    ),
                    backgroundColor: e == state.type ? Palette.text100 : null,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
