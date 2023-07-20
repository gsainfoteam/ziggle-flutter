import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/global_widgets/article_card.dart';
import 'package:ziggle/app/modules/home/controller.dart';
import 'package:ziggle/gen/assets.gen.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: controller.reload,
      key: controller.refreshIndicatorKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _buildSectionHeader(ArticleType.deadline),
          const SizedBox(height: 8),
          Obx(_buildDeadlineArticles),
          ...ArticleType.verticals.expand(
            (e) => [
              const SizedBox(height: 30),
              _buildSectionHeader(e),
              const SizedBox(height: 8),
              Obx(() => _buildMasonryArticles(controller.articles[e]!))
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ArticleType type) {
    return GestureDetector(
      onTap: () => controller.goToList(type),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(type.header, style: TextStyles.articleTitleStyle),
          Assets.icons.rightArrow.image(width: 18, height: 18),
        ],
      ),
    ).paddingSymmetric(horizontal: 20);
  }

  Widget _buildDeadlineArticles() {
    final rxn = controller.articles[ArticleType.deadline]!;
    if (rxn.value == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 170,
      child: LayoutBuilder(builder: (context, constraints) {
        return PageView.builder(
          clipBehavior: Clip.none,
          controller: PageController(
            viewportFraction: 1 - (30 / constraints.maxWidth),
          ),
          allowImplicitScrolling: true,
          itemCount: rxn.value!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ArticleCard(
                article: rxn.value![index],
                direction: Axis.horizontal,
                onTap: () => controller.goToDetail(rxn.value![index].id),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildMasonryArticles(Rxn<List<ArticleSummaryResponse>> articles) {
    if (articles.value == null) {
      return const SizedBox.shrink();
    }
    return MasonryGridView.extent(
      maxCrossAxisExtent: 300,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      itemCount: articles.value!.length,
      itemBuilder: (context, index) => ArticleCard(
        article: articles.value![index],
        onTap: () => controller.goToDetail(articles.value![index].id),
      ),
    );
  }
}
