import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/global_widgets/article_card.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/modules/search/controller.dart';
import 'package:ziggle/app/routes/pages.dart';

class SearchPage extends GetView<SearchController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      displacement: 150,
      onRefresh: controller.search,
      notificationPredicate: (_) => false,
      key: controller.refreshIndicatorKey,
      child: CustomScrollView(
        clipBehavior: Clip.none,
        slivers: [
          SliverAppBar(
            toolbarHeight: 132,
            floating: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Color(0x00ffffff),
                    ],
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    _buildSearchBox(),
                    const SizedBox(height: 8),
                    _buildTypes(),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),
          Obx(() => controller.articles.value == null
              ? _buildEnterQuery()
              : _buildArticles()),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return TextField(
      style: TextStyles.label.copyWith(color: Palette.primaryColor),
      onChanged: controller.query,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide.none,
        ),
        fillColor: Palette.light,
        filled: true,
        hintText: '강의명/교수명/과목코드',
        hintStyle: TextStyles.secondaryLabelStyle,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        isCollapsed: true,
        suffixIcon: Icon(
          Icons.search,
          color: Palette.secondaryText,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildTypes() {
    return Wrap(
      spacing: 8,
      children: ArticleType.searchables
          .map(
            (type) => Obx(() => ZiggleButton(
                  onTap: () => controller.selectedType(type),
                  text: type.label,
                  color: controller.selectedType.value == type
                      ? Palette.primaryColor
                      : Palette.light,
                  textStyle: TextStyles.defaultStyle.copyWith(
                    color: controller.selectedType.value == type
                        ? Palette.white
                        : null,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                )),
          )
          .toList(),
    );
  }

  Widget _buildEnterQuery() {
    return const SliverToBoxAdapter(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 32),
            Icon(
              Icons.search,
              size: 100,
              color: Palette.secondaryText,
            ),
            Text(
              '검색어를 입력해주세요',
              style: TextStyles.secondaryLabelStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticles() {
    assert(controller.articles.value != null);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList.builder(
        itemCount: controller.articles.value!.length,
        itemBuilder: (context, index) => ArticleCard(
          article: controller.articles.value![index],
          direction: Axis.horizontal,
          onTap: () => Get.toNamed(Routes.ARTICLE, parameters: {
            'id': controller.articles.value![index].id.toString(),
          }),
        ).paddingOnly(bottom: 18),
      ),
    );
  }
}
