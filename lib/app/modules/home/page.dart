import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/global_widgets/article_card.dart';
import 'package:ziggle/app/global_widgets/section_header.dart';
import 'package:ziggle/app/modules/home/controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: controller.reload,
      key: controller.refreshIndicatorKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: ArticleType.main
            .expand(
              (e) => [
                SectionHeader(type: e, onTap: () => controller.goToList(e))
                    .paddingSymmetric(horizontal: 20),
                const SizedBox(height: 8),
                Obx(() => _buildArticles(e)),
                const SizedBox(height: 30),
              ],
            )
            .toList(),
      ),
    );
  }

  Widget _buildArticles(ArticleType type) {
    final articles = controller.articles[type]!;
    if (articles.value == null) {
      return const SizedBox.shrink();
    }
    if (!type.isHorizontal) {
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
    return SizedBox(
      height: kArticleCardHeight,
      child: LayoutBuilder(builder: (context, constraints) {
        return PageView.builder(
          clipBehavior: Clip.none,
          controller: PageController(
            viewportFraction: 1 - (30 / constraints.maxWidth),
          ),
          allowImplicitScrolling: true,
          itemCount: articles.value!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ArticleCard(
                article: articles.value![index],
                direction: Axis.horizontal,
                onTap: () => controller.goToDetail(articles.value![index].id),
              ),
            );
          },
        );
      }),
    );
  }
}
