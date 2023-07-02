import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/global_widgets/article_card.dart';
import 'package:ziggle/app/modules/home/controller.dart';
import 'package:ziggle/app/routes/pages.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: [
        const Text('기한 임박').paddingSymmetric(horizontal: 20),
        Obx(_buildDeadlineArticles),
        const Text('요즘 끓는 공지'),
        Obx(_buildHotArticles),
      ],
    );
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

  Widget _buildHotArticles() {
    if (controller.hotArticles.value == null) {
      return const SizedBox.shrink();
    }
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      itemCount: controller.hotArticles.value!.length,
      itemBuilder: (context, index) => ArticleCard(
        article: controller.hotArticles.value![index],
        onTap: () => Get.toNamed(Routes.ARTICLE, parameters: {
          'id': controller.hotArticles.value![index].id.toString(),
        }),
      ),
    );
  }
}
