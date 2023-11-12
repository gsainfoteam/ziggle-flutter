import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/common/presentaion/widgets/article_card.dart';
import 'package:ziggle/app/common/presentaion/widgets/section_header.dart';
import 'package:ziggle/app/modules/home/controller.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: controller.reload,
      key: controller.refreshIndicatorKey,
      child: Obx(
        () => ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: NoticeType.main
              .where((e) => controller.articles[e]?.value?.isNotEmpty ?? false)
              .expand(
                (e) => [
                  SectionHeader(type: e, onTap: () => controller.goToList(e))
                      .paddingSymmetric(horizontal: 20),
                  const SizedBox(height: 8),
                  _buildArticles(e),
                  if (e.noPreview)
                    const SizedBox(height: 16)
                  else
                    const SizedBox(height: 30),
                ],
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildArticles(NoticeType type) {
    final articles = controller.articles[type]?.value;
    if (articles == null || type.noPreview) {
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
        itemCount: articles.length,
        itemBuilder: (context, index) => ArticleCard(
          article: articles[index],
          onTap: () => controller.goToDetail(articles[index].id),
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
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ArticleCard(
                article: articles[index],
                direction: Axis.horizontal,
                onTap: () => controller.goToDetail(articles[index].id),
              ),
            );
          },
        );
      }),
    );
  }
}
