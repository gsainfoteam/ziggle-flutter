import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ziggle/app/common/presentaion/widgets/article_card.dart';
import 'package:ziggle/app/core/routes/routes.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/utils/functions/calculate_date_delta.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_summary_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeSectionPage extends StatefulWidget {
  final NoticeType type;
  const NoticeSectionPage({super.key, required this.type});

  @override
  State<NoticeSectionPage> createState() => _NoticeSectionPageState();
}

typedef _GroupNotice = MapEntry<DateTime, List<NoticeSummaryEntity>>;

class _NoticeSectionPageState extends State<NoticeSectionPage> {
  final articleController =
      PagingController<int, NoticeSummaryEntity>(firstPageKey: 1);
  final groupArticleController =
      PagingController<int, _GroupNotice>(firstPageKey: 1);

  @override
  void dispose() {
    articleController.dispose();
    groupArticleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.type.title)),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          widget.type == NoticeType.deadline
              ? groupArticleController.refresh()
              : articleController.refresh();
        },
        child: CustomScrollView(
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: widget.type == NoticeType.deadline
                  ? _buildDeadlineList()
                  : _buildSimpleList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeadlineList() {
    return PagedSliverList<int, _GroupNotice>.separated(
      pagingController: groupArticleController,
      separatorBuilder: (context, index) => const SizedBox(height: 18),
      builderDelegate: PagedChildBuilderDelegate(
        firstPageProgressIndicatorBuilder: (_) => const _ProgressIndicator(),
        newPageProgressIndicatorBuilder: (_) => const _ProgressIndicator(),
        noItemsFoundIndicatorBuilder: (_) => const _NoItemsFoundIndicator(),
        itemBuilder: (context, item, index) => Column(
          children: [
            Text(
              t.article.deadlineDelta(
                n: calculateDateDelta(DateTime.now(), item.key),
              ),
              style: TextStyles.articleCardTitleStyle,
            ),
            const SizedBox(height: 12),
            Container(width: 80, height: 1, color: Palette.black),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: item.value
                  .map(
                    (article) => Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: NoticeCard(
                        notice: article,
                        direction: Axis.horizontal,
                        onTap: () =>
                            context.push(Paths.articleDetail, extra: article),
                      ),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleList() {
    return PagedSliverList<int, NoticeSummaryEntity>.separated(
      pagingController: articleController,
      separatorBuilder: (context, index) => const SizedBox(height: 18),
      builderDelegate: PagedChildBuilderDelegate(
        firstPageProgressIndicatorBuilder: (_) => const _ProgressIndicator(),
        newPageProgressIndicatorBuilder: (_) => const _ProgressIndicator(),
        noItemsFoundIndicatorBuilder: (_) => const _NoItemsFoundIndicator(),
        itemBuilder: (context, item, index) => NoticeCard(
          notice: item,
          direction: Axis.horizontal,
          onTap: () => context.push(Paths.articleDetail, extra: item),
        ),
      ),
    );
  }
}

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
