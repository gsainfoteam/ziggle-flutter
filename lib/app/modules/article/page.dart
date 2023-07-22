import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/core/values/shadows.dart';
import 'package:ziggle/app/global_widgets/bottom_sheet.dart';
import 'package:ziggle/app/modules/article/article_body.dart';
import 'package:ziggle/app/modules/article/controller.dart';
import 'package:ziggle/app/modules/article/page_spinner.dart';
import 'package:ziggle/gen/strings.g.dart';

class ArticlePage extends GetView<ArticleController> {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.article.value?.title ?? '')),
        actions: [
          Obx(
            () => controller.article.value?.deadline == null
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: controller.toggleReminder,
                    icon: Icon(
                      Icons.notifications_active,
                      color: controller.isReminder.value
                          ? Palette.black
                          : Palette.deselected,
                    ),
                  ),
          ),
        ],
      ),
      body: Obx(_buildInner),
    );
  }

  Widget _buildInner() {
    if (controller.article.value == null) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    final article = controller.article.value!;
    final child = SafeArea(child: ArticleBody(article: article));

    final imagesUrls = article.imagesUrl;
    if (imagesUrls == null || imagesUrls.isEmpty) {
      return Stack(
        children: [
          SingleChildScrollView(child: child),
          Obx(_buildReminderTooltip),
        ],
      );
    }
    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          if (controller.scrollPixel.value == 0) {
            controller.scrollPixel.value = constraints.maxHeight * 0.25;
          }
          final minHeight = constraints.maxHeight * 0.25 + 15 * 2 + 20 + 43;
          return Obx(() => Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                height: max(
                  constraints.maxHeight - controller.scrollPixel.value,
                  minHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: _buildImageCarousel(imagesUrls)),
                    const SizedBox(height: 20),
                    PageSpinner(
                      currentPage: controller.page.value,
                      maxPage: imagesUrls.length,
                      onPageChanged: controller.onPageChanged,
                    ),
                  ],
                ),
              ));
        }),
        Obx(_buildReminderTooltip),
        DraggableScrollableSheet(
          controller: controller.scrollController,
          initialChildSize: 0.25,
          builder: (context, scrollController) => ZiggleBottomSheet(
            scrollController: scrollController,
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildReminderTooltip() {
    if (!controller.showReminderTooltip.value) return const SizedBox.shrink();
    return Positioned(
      top: 0,
      right: 20,
      child: _Tooltip(controller.closeTooltip),
    );
  }

  Widget _buildImageCarousel(List<String> imageUrls) {
    return PageView.builder(
      clipBehavior: Clip.none,
      controller: controller.pageController,
      itemCount: imageUrls.length,
      itemBuilder: (context, index) => Center(
        child: GestureDetector(
          onTap: () => controller.onImageTap(index),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: frameShadows,
            ),
            child: Hero(
              tag: index,
              child: CachedNetworkImage(
                imageUrl: imageUrls[index],
                fit: BoxFit.contain,
                placeholder: (_, __) =>
                    const CircularProgressIndicator.adaptive(),
              ),
            ),
          ).paddingSymmetric(horizontal: 50),
        ),
      ),
    );
  }
}

class _Tooltip extends StatelessWidget {
  final void Function()? onClose;
  const _Tooltip(this.onClose);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: _TriangleDecoration(),
        ),
        Container(
          padding: const EdgeInsets.only(right: 18),
          decoration: BoxDecoration(
            color: Palette.primaryColor,
            borderRadius: BorderRadius.circular(10) -
                const BorderRadius.only(topRight: Radius.circular(10)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close),
                iconSize: 20,
                color: Palette.white,
                padding: EdgeInsets.zero,
              ),
              Text(
                t.article.reminderDescription,
                style: TextStyles.tooltipStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TriangleDecoration extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _TrianglePainter();
  }
}

class _TrianglePainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..color = Palette.primaryColor
      ..style = PaintingStyle.fill;
    final bounds = offset & configuration.size!;
    final path = Path()
      ..moveTo(bounds.right, bounds.top)
      ..lineTo(bounds.right, bounds.bottom)
      ..lineTo(bounds.left, bounds.bottom)
      ..close();
    canvas.drawPath(path, paint);
  }
}
