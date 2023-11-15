import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/common/presentaion/widgets/article_card.dart';
import 'package:ziggle/app/common/presentaion/widgets/button.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/core/routes/routes.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_search_query_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notices/notices_bloc.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<NoticesBloc>()),
      ],
      child: const _Layout(),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  double _toolbarHeight = 0.0;
  final _toolbarKey = GlobalKey();
  final _query = ValueNotifier("");
  final _scrollController = ScrollController();
  final _types = ValueNotifier<Set<NoticeType>>({});

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll - 200;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshIndicatorKey.currentState?.show();
      final toolbarRenderBox =
          _toolbarKey.currentContext!.findRenderObject() as RenderBox;
      setState(() => _toolbarHeight = toolbarRenderBox.size.height);
    });
    _query.addListener(_onChangeQuery);
    _types.addListener(_onChangeQuery);
    _scrollController.addListener(_onScroll);
  }

  void _onChangeQuery() {
    context.read<NoticesBloc>().add(
          NoticesEvent.fetch(
            NoticeSearchQueryEntity(
              search: _query.value,
              tags: _types.value.map((e) => e.name).toList(),
            ),
          ),
        );
    sl<AnalyticsRepository>().logSearch(_query.value, _types.value);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<NoticesBloc>().add(const NoticesEvent.loadMore());
    }
  }

  @override
  void dispose() {
    _query
      ..removeListener(_onChangeQuery)
      ..dispose();
    _types
      ..removeListener(_onChangeQuery)
      ..dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      edgeOffset: _toolbarHeight,
      key: _refreshIndicatorKey,
      onRefresh: () async {
        _scrollController.jumpTo(0);
        _onChangeQuery();
        await context.read<NoticesBloc>().stream.firstWhere((s) => s.loaded);
      },
      child: CustomScrollView(
        clipBehavior: Clip.none,
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            toolbarHeight: _toolbarHeight,
            floating: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                key: _toolbarKey,
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
          ),
          _buildArticles(),
          _buildEmpty(),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return TextField(
      style: TextStyles.label.copyWith(color: Palette.primaryColor),
      onChanged: (v) => _query.value = v,
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
      children: NoticeType.searchables
          .map(
            (type) => ZiggleButton(
              onTap: () => setState(() => _types.toggle(type)),
              text: type.label,
              color: _types.value.contains(type)
                  ? Palette.primaryColor
                  : Palette.light,
              textStyle: TextStyles.defaultStyle.copyWith(
                color: _types.value.contains(type) ? Palette.white : null,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          )
          .toList(),
    );
  }

  Widget _buildArticles() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: BlocBuilder<NoticesBloc, NoticesState>(
        builder: (context, state) => SliverList.separated(
          itemCount: state.notices.length,
          separatorBuilder: (context, index) => const SizedBox(height: 18),
          itemBuilder: (context, index) => NoticeCard(
            notice: state.notices[index],
            direction: Axis.horizontal,
            showType: true,
            onTap: () => context.push(
              Paths.articleDetail,
              extra: state.notices[index],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return SliverToBoxAdapter(
      child: BlocBuilder<NoticesBloc, NoticesState>(
        builder: (context, state) => state.notices.isNotEmpty
            ? const SizedBox()
            : _query.value.isEmpty
                ? const SingleChildScrollView(child: _EnterQuery())
                : const _NoResult(),
      ),
    );
  }
}

class _EnterQuery extends StatelessWidget {
  const _EnterQuery();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 32),
        const Icon(Icons.search, size: 100, color: Palette.secondaryText),
        Text(t.search.enter, style: TextStyles.secondaryLabelStyle),
      ],
    );
  }
}

class _NoResult extends StatelessWidget {
  const _NoResult();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.images.noResult.image(width: 160),
        const SizedBox(height: 16),
        Text(
          t.search.noResult,
          style: TextStyles.secondaryLabelStyle,
        ),
      ],
    );
  }
}

extension _Toggle on ValueNotifier<Set<NoticeType>> {
  void toggle(NoticeType type) {
    if (value.contains(type)) {
      value.remove(type);
    } else {
      value.add(type);
    }
    value = {...value};
  }
}
