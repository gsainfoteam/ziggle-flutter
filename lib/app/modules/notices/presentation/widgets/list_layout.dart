import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_list_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/infinite_scroll.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/notice_card.dart';
import 'package:ziggle/app/router.gr.dart';

class ListLayout extends StatelessWidget {
  const ListLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoticeListBloc, NoticeListState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => NoticeListBloc.refresh(context),
          child: state.showLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : InfiniteScroll(
                  onLoadMore: () => NoticeListBloc.loadMore(context),
                  slivers: [
                    SliverSafeArea(
                      top: false,
                      sliver: SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        sliver: SliverList.separated(
                          itemBuilder: (context, index) {
                            if (index >= state.notices.length) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final notice = state.notices[index];
                            return NoticeCard(
                              onLike: () {},
                              onPressed: () =>
                                  SingleNoticeShellRoute(notice: notice)
                                      .push(context),
                              onShare: () {},
                              notice: notice,
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 15),
                          itemCount:
                              state.notices.length + (state.isLoading ? 1 : 0),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
