import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/utils/extension/date_align.dart';
import 'package:ziggle/app/core/utils/functions/calculate_date_delta.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/global_widgets/article_card.dart';
import 'package:ziggle/app/modules/article_section/controller.dart';

class ArticleSectionPage extends GetView<ArticleSectionController> {
  const ArticleSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.type.title),
      ),
      body: CustomScrollView(
        slivers: [
          Column(
            children: [
              Text(controller.type.emoji,
                  style: const TextStyle(fontSize: 140)),
              Text(controller.type.title, style: TextStyles.articleTitleStyle),
              Text(
                controller.type.description,
                textAlign: TextAlign.center,
                style: TextStyles.articleCardAuthorStyle,
              ),
              const SizedBox(height: 50),
            ],
          ).sliverBox,
          Obx(
            () => controller.articles.value == null
                ? const SizedBox.shrink().sliverBox
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: controller.type == ArticleType.deadline
                        ? Obx(_buildDeadlineList)
                        : Obx(_buildSimpleList),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineList() {
    final articles = groupBy(
      controller.articles.value!,
      (article) => article.deadline!.aligned,
    ).entries.toList();
    return SliverList.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Text(
              '${calculateDateDelta(DateTime.now(), articles[index].key)}일 남음',
              style: TextStyles.articleCardTitleStyle,
            ),
            const SizedBox(height: 12),
            Container(width: 80, height: 1, color: Palette.black),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: articles[index]
                  .value
                  .map(
                    (article) => SizedBox(
                      height: 170,
                      child: ArticleCard(
                        article: article,
                        direction: Axis.horizontal,
                        onTap: () => controller.goToDetail(article.id),
                      ),
                    ).marginOnly(bottom: 18),
                  )
                  .toList(),
            )
          ],
        );
      },
    );
  }

  Widget _buildSimpleList() {
    final articles = controller.articles.value!;
    return SliverList.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 170,
          child: ArticleCard(
            article: articles[index],
            direction: Axis.horizontal,
            onTap: () => controller.goToDetail(articles[index].id),
          ),
        ).marginOnly(bottom: 18);
      },
    );
  }
}
