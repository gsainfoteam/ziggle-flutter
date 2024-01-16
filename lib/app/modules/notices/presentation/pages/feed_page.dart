import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

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
            ..add(const NoticeListEvent.load());
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
                  onPressed: () {},
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(bottomHeight),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Wrap(
                      spacing: 8,
                      children: NoticeType.sections
                          .map(
                            (e) => ActionChip.elevated(
                              labelPadding: const EdgeInsets.only(right: 8),
                              avatar: e.icon.image(
                                width: 16,
                                color: e == NoticeType.all
                                    ? Palette.background100
                                    : null,
                              ),
                              label: Text(e.label),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                              },
                              labelStyle: TextStyle(
                                color: e == NoticeType.all
                                    ? Palette.background100
                                    : null,
                              ),
                              backgroundColor:
                                  e == NoticeType.all ? Palette.text100 : null,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
            SliverSafeArea(
              top: false,
              sliver: BlocBuilder<NoticeListBloc, NoticeListState>(
                builder: (context, state) => SliverList.separated(
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    final notice = state.list[index];
                    return NoticeCard(
                      notice: notice,
                      onTapDetail: () => NoticeRoute(
                        id: notice.id,
                        $extra: notice,
                      ).push(context),
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
}
