import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/global_widgets/article_card.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/modules/search/controller.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

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
          Obx(() => SliverAppBar(
                toolbarHeight: controller.toolbarHeight.value,
                floating: true,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Container(
                    key: controller.toolbarKey,
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
                      mainAxisAlignment: MainAxisAlignment.start,
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
              )),
          _buildArticles(),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return TextField(
      style: TextStyles.label.copyWith(color: Palette.primaryColor),
      onChanged: controller.query,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide.none,
        ),
        fillColor: Palette.light,
        filled: true,
        hintText: t.search.queryHint,
        hintStyle: TextStyles.secondaryLabelStyle,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        isCollapsed: true,
        suffixIcon: const Icon(
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
      runSpacing: 8,
      children: ArticleType.searchables
          .map(
            (type) => Obx(() => ZiggleButton(
                  onTap: () => controller.toggleType(type),
                  text: type.label,
                  color: controller.selectedType.contains(type)
                      ? Palette.primaryColor
                      : Palette.light,
                  textStyle: TextStyles.defaultStyle.copyWith(
                    color: controller.selectedType.contains(type)
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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32),
          const Icon(Icons.search, size: 100, color: Palette.secondaryText),
          Text(t.search.enter, style: TextStyles.secondaryLabelStyle),
        ],
      ),
    );
  }

  Widget _buildArticles() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: PagedSliverList<int, ArticleSummaryResponse>(
        pagingController: controller.pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          noItemsFoundIndicatorBuilder: (context) => controller.query.isEmpty
              ? _buildEnterQuery()
              : Column(children: [
                  Assets.images.noResult.image(width: 160),
                  const SizedBox(height: 16),
                  Text(
                    t.search.noResult,
                    style: TextStyles.secondaryLabelStyle,
                  ),
                ]),
          itemBuilder: (context, item, index) => ArticleCard(
            article: item,
            direction: Axis.horizontal,
            showType: true,
            onTap: () => controller.goToDetail(item.id),
          ).paddingOnly(bottom: 18),
        ),
      ),
    );
  }
}
