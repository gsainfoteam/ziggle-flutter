import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ziggle/gen/assets.gen.dart';

class BannerEntry {
  const BannerEntry({required this.asset, this.onTap});

  final AssetGenImage asset;
  final VoidCallback? onTap;
}

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({
    super.key,
    required this.banners,
    this.height = 70,
    this.horizontalPadding = 16,
    this.verticalPadding = 16,
    this.autoScrollDuration = const Duration(seconds: 5),
    this.borderRadius = 12,
  });

  final List<BannerEntry> banners;
  final double height;
  final double horizontalPadding;
  final double verticalPadding;
  final Duration autoScrollDuration;
  final double borderRadius;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.banners.length > 1) {
      _timer = Timer.periodic(widget.autoScrollDuration, (_) => _nextPage());
    }
  }

  @override
  void didUpdateWidget(covariant BannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldLength = oldWidget.banners.length;
    final newLength = widget.banners.length;

    if (oldLength != newLength) {
      if (_pageController.hasClients && widget.banners.isNotEmpty) {
        _pageController.jumpToPage(0);
      }

      if (newLength <= 1) {
        _timer?.cancel();
        _timer = null;
      } else if (oldLength <= 1) {
        _timer = Timer.periodic(widget.autoScrollDuration, (_) => _nextPage());
      }
    }
  }

  void _nextPage() {
    if (!_pageController.hasClients || widget.banners.isEmpty) return;
    final current = _pageController.page?.round() ?? 0;
    final next = (current + 1) % widget.banners.length;
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    if (banners.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.horizontalPadding,
        vertical: widget.verticalPadding,
      ).copyWith(bottom: 0),
      child: SizedBox(
        height: widget.height,
        child: PageView.builder(
          controller: _pageController,
          physics: banners.length == 1
              ? const NeverScrollableScrollPhysics()
              : null,
          itemCount: banners.length,
          itemBuilder: (context, index) => _BannerItem(
            entry: banners[index],
            height: widget.height,
            borderRadius: widget.borderRadius,
          ),
        ),
      ),
    );
  }
}

class _BannerItem extends StatelessWidget {
  const _BannerItem({
    required this.entry,
    required this.height,
    required this.borderRadius,
  });

  final BannerEntry entry;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: entry.asset.image(fit: BoxFit.cover),
      ),
    );

    final onTap = entry.onTap;
    if (onTap == null) return content;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }
}
