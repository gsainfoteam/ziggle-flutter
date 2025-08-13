import 'package:flutter/material.dart';

class InfiniteScroll extends StatefulWidget {
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
  State<InfiniteScroll> createState() => _InfiniteScrollState();
}

class _InfiniteScrollState extends State<InfiniteScroll> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  bool get _isBottom {
    if (!_controller.hasClients) return false;
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    return currentScroll >= maxScroll - widget.threshold;
  }

  void _onScroll() {
    if (_isBottom) widget.onLoadMore();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      slivers: widget.slivers,
    );
  }
}
