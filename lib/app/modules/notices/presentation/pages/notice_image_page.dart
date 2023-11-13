import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/page_spinner.dart';

class NoticeImagePage extends StatefulWidget {
  final int page;
  final List<String> images;
  const NoticeImagePage({super.key, required this.page, required this.images});

  @override
  State<NoticeImagePage> createState() => _NoticeImagePageState();
}

class _NoticeImagePageState extends State<NoticeImagePage> {
  late int _page = widget.page;
  late final _pageController = PageController(initialPage: widget.page - 1);

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() => _page = (_pageController.page?.toInt() ?? 0) + 1);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Palette.black,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: CloseButton(onPressed: () => context.pop(_page)),
          backgroundColor: Colors.transparent,
          foregroundColor: Palette.white,
        ),
        backgroundColor: Palette.black,
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              itemBuilder: (context, index) => Hero(
                tag: index,
                child: InteractiveViewer(
                  child: CachedNetworkImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.6),
              child: PageSpinner(
                isLight: false,
                currentPage: _page,
                maxPage: widget.images.length,
                onPageChanged: (page) => _pageController.animateToPage(
                  page - 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
