import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/global_widgets/article_card.dart';
import 'package:ziggle/app/modules/home/controller.dart';
import 'package:ziggle/app/routes/pages.dart';
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
          _buildSectionHeader('🌟 기한 임박', controller.goToDeadline),
          const SizedBox(height: 8),
          Obx(_buildDeadlineArticles),
          const SizedBox(height: 30),
          _buildSectionHeader('🔥 요즘 끓는 공지', controller.goToHot),
          const SizedBox(height: 8),
          Obx(() => _buildVerticalArticles(controller.hotArticles)),
          const SizedBox(height: 30),
          _buildSectionHeader('🎈 행사', controller.goToEvent),
          const SizedBox(height: 8),
          Obx(() => _buildVerticalArticles(controller.deadlineArticles)),
          const SizedBox(height: 30),
          _buildSectionHeader('🎯 모집', controller.goToRecruit),
          const SizedBox(height: 8),
          Obx(() => _buildVerticalArticles(controller.recruitArticles)),
          const SizedBox(height: 30),
          _buildSectionHeader('🔔 일반', controller.goToGeneral),
          const SizedBox(height: 8),
          Obx(() => _buildVerticalArticles(controller.generalArticles)),
          const SizedBox(height: 30),
          _buildSectionHeader('🔔 학사공지', controller.goToAcademic),
          const SizedBox(height: 8),
          Obx(() => _buildVerticalArticles(controller.academicArticles)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String label, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.articleTitleStyle),
          Assets.icons.rightArrow.image(width: 18, height: 18),
        ],
      ),
    ).paddingSymmetric(horizontal: 20);
  }

  Widget _buildDeadlineArticles() {
    if (controller.deadlineArticles.value == null) {
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
          itemCount: controller.deadlineArticles.value!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ArticleCard(
                article: controller.deadlineArticles.value![index],
                direction: Axis.horizontal,
                onTap: () => Get.toNamed(Routes.ARTICLE, parameters: {
                  'id': controller.deadlineArticles.value![index].id.toString(),
                }),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildVerticalArticles(Rxn<List<ArticleSummaryResponse>> articles) {
    if (articles.value == null) {
      return const SizedBox.shrink();
    }
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      itemCount: articles.value!.length,
      itemBuilder: (context, index) => ArticleCard(
        article: articles.value![index],
        onTap: () => Get.toNamed(Routes.ARTICLE, parameters: {
          'id': articles.value![index].id.toString(),
        }),
      ),
    );
  }
}
