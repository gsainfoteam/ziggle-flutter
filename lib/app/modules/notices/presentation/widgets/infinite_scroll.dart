import 'package:flutter/material.dart';

class InfiniteScroll extends StatelessWidget {
  const InfiniteScroll({
    super.key,
    required this.onLoadMore,
    required this.slivers,
    this.threshold = 200,
    this.controller,
  });

  final VoidCallback onLoadMore;
  final List<Widget> slivers;
  final int threshold;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return _Inner(
      controller: controller ?? PrimaryScrollController.of(context),
      onLoadMore: onLoadMore,
      slivers: slivers,
      threshold: threshold,
    );
  }
}

class _Inner extends StatefulWidget {
  const _Inner({
    required this.onLoadMore,
    required this.slivers,
    this.threshold = 200,
    required this.controller,
  });

  final ScrollController controller;
  final VoidCallback onLoadMore;
  final List<Widget> slivers;
  final int threshold;

  @override
  State<_Inner> createState() => _InnerState();
}

class _InnerState extends State<_Inner> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  bool get _isBottom {
    if (!widget.controller.hasClients) return false;
    final maxScroll = widget.controller.position.maxScrollExtent;
    final currentScroll = widget.controller.offset;
    return currentScroll >= maxScroll - widget.threshold;
  }

  void _onScroll() {
    if (_isBottom) widget.onLoadMore();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      controller: widget.controller,
      slivers: widget.slivers,
    );
  }
}
