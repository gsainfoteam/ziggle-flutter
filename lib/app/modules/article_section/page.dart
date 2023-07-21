import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/utils/functions/calculate_date_delta.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/global_widgets/article_card.dart';
import 'package:ziggle/app/modules/article_section/controller.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class ArticleSectionPage extends GetView<ArticleSectionController> {
  const ArticleSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.type.title),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () => Future.wait([
          Future.sync(controller.articleController.refresh),
          Future.sync(controller.groupArticleController.refresh),
        ]),
        child: CustomScrollView(
          slivers: [
            Column(
              children: [
                Text(controller.type.emoji,
                    style: const TextStyle(fontSize: 140)),
                Text(controller.type.title,
                    style: TextStyles.articleTitleStyle),
                Text(
                  controller.type.description,
                  textAlign: TextAlign.center,
                  style: TextStyles.articleCardAuthorStyle,
                ),
                const SizedBox(height: 50),
              ],
            ).sliverBox,
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: controller.type == ArticleType.deadline
                  ? _buildDeadlineList()
                  : _buildSimpleList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressIndicatorBuilder(BuildContext context) =>
      const Center(child: CircularProgressIndicator.adaptive())
          .paddingSymmetric(vertical: 16);

  Widget _noItemsFoundIndicatorBuilder(BuildContext context) => Column(
        children: [
          Assets.images.noResult.image(width: 160),
          const SizedBox(height: 16),
          Text(t.search.noResult, style: TextStyles.secondaryLabelStyle),
        ],
      );

  Widget _buildDeadlineList() {
    return PagedSliverList<int,
        MapEntry<DateTime, List<ArticleSummaryResponse>>>(
      pagingController: controller.groupArticleController,
      builderDelegate: PagedChildBuilderDelegate(
        firstPageProgressIndicatorBuilder: _progressIndicatorBuilder,
        newPageProgressIndicatorBuilder: _progressIndicatorBuilder,
        noItemsFoundIndicatorBuilder: _noItemsFoundIndicatorBuilder,
        itemBuilder: (context, item, index) => Column(
          children: [
            Text(
              '${calculateDateDelta(DateTime.now(), item.key)}일 남음',
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
                    (article) => ArticleCard(
                      article: article,
                      direction: Axis.horizontal,
                      onTap: () => controller.goToDetail(article.id),
                    ).marginOnly(bottom: 18),
                  )
                  .toList(),
            )
          ],
        ).marginOnly(bottom: 18),
      ),
    );
  }

  Widget _buildSimpleList() {
    return PagedSliverList<int, ArticleSummaryResponse>(
      pagingController: controller.articleController,
      builderDelegate: PagedChildBuilderDelegate(
        firstPageProgressIndicatorBuilder: _progressIndicatorBuilder,
        newPageProgressIndicatorBuilder: _progressIndicatorBuilder,
        noItemsFoundIndicatorBuilder: _noItemsFoundIndicatorBuilder,
        itemBuilder: (context, item, index) => ArticleCard(
          article: item,
          direction: Axis.horizontal,
          onTap: () => controller.goToDetail(item.id),
        ).marginOnly(bottom: 18),
      ),
    );
  }
}
