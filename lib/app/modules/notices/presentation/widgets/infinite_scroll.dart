import 'package:flutter/material.dart';

class InfiniteScroll extends StatefulWidget {
  const InfiniteScroll({
    super.key,
    required this.onLoadMore,
    required this.slivers,
    this.threshold = 200,
  });

  final VoidCallback onLoadMore;
  final List<Widget> slivers;
  final int threshold;

  @override
  State<InfiniteScroll> createState() => _InfiniteScrollState();
}

class _InfiniteScrollState extends State<InfiniteScroll> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll - widget.threshold;
  }

  void _onScroll() {
    if (_isBottom) widget.onLoadMore();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: widget.slivers,
    );
  }
}
