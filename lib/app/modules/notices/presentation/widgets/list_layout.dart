import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/promotion_button.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_reaction.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_list_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/cubit/share_cubit.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/infinite_scroll.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/notice_card.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/strings.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class ListLayout extends StatelessWidget {
  const ListLayout({super.key, required this.noticeType});

  final NoticeType noticeType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoticeListBloc, NoticeListState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => NoticeListBloc.refresh(context),
          child: state.showLoading
              ? Center(
                  child: Lottie.asset(Assets.lotties.loading,
                      height: MediaQuery.of(context).size.width * 0.2,
                      width: MediaQuery.of(context).size.width * 0.2),
                )
              : InfiniteScroll(
                  onLoadMore: () => NoticeListBloc.loadMore(context),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(
                        child: PromotionButton(
                          title: context.t.promotion.recruiting.title,
                          subtitle: context.t.promotion.recruiting.description,
                          onPressed: () => launchUrl(
                            Uri.parse(Strings.recruitmentUrl),
                            mode: LaunchMode.externalApplication,
                          ),
                          icon: Assets.logo.infoteam.svg(),
                        ),
                      ),
                    ),
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
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Lottie.asset(Assets.lotties.loading,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.2),
                                ),
                              );
                            }
                            final notice = state.notices[index];
                            return NoticeCard(
                              onLike: () {
                                AnalyticsRepository.click(
                                    AnalyticsEvent.noticeReaction(
                                        notice.id,
                                        NoticeReaction.like,
                                        noticeType == NoticeType.all
                                            ? PageSource.feed
                                            : PageSource.list));
                                if (UserBloc.userOrNull(context) == null) {
                                  return context.showToast(
                                    context.t.user.login.description,
                                  );
                                }
                                context.read<NoticeListBloc>().add(
                                      notice.reacted(NoticeReaction.like)
                                          ? NoticeListEvent.removeLike(notice)
                                          : NoticeListEvent.addLike(notice),
                                    );
                              },
                              onPressed: () {
                                AnalyticsRepository.click(AnalyticsEvent.notice(
                                    notice.id,
                                    noticeType == NoticeType.all
                                        ? PageSource.feed
                                        : PageSource.list));
                                SingleNoticeShellRoute(notice: notice)
                                    .push(context);
                              },
                              onShare: () {
                                AnalyticsRepository.click(
                                    AnalyticsEvent.noticeShare(
                                        notice.id,
                                        noticeType == NoticeType.all
                                            ? PageSource.feed
                                            : PageSource.list));
                                context.read<ShareCubit>().share(notice);
                              },
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
