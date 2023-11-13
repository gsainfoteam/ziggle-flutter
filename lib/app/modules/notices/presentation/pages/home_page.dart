import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/common/presentaion/widgets/article_card.dart';
import 'package:ziggle/app/common/presentaion/widgets/section_header.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/core/routes/routes.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_search_query_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notices/notices_bloc.dart';

import '../../domain/enums/notice_type.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => refreshIndicatorKey.currentState?.show());

    return RefreshIndicator.adaptive(
      key: refreshIndicatorKey,
      onRefresh: () async {
        context
            .read<NoticesBloc>()
            .add(NoticesEvent.fetch(NoticeSearchQueryEntity()));
        // await context
        //     .read<NoticesBloc>()
        //     .stream
        //     .where((event) => event.fullyLoaded)
        //     .first;
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: NoticeType.main
            // .where((e) => controller.articles[e]?.value?.isNotEmpty ?? false)
            .expand(
              (e) => [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    type: e,
                    onTap: () => context.push(Paths.articleSection(e)),
                  ),
                ),
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
    );
  }

  Widget _buildArticles(NoticeType type) {
    // final articles = controller.articles[type]?.value;
    const List<ArticleSummaryResponse>? articles = null;
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
          onTap: () => context.push(Paths.articleDetail(articles[index].id)),
        ),
      );
    }
    return SizedBox(
      height: kArticleCardHeight,
      child: LayoutBuilder(
        builder: (context, constraints) => PageView.builder(
          clipBehavior: Clip.none,
          controller: PageController(
            viewportFraction: 1 - (30 / constraints.maxWidth),
          ),
          allowImplicitScrolling: true,
          itemCount: articles.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ArticleCard(
              article: articles[index],
              direction: Axis.horizontal,
              onTap: () =>
                  context.push(Paths.articleDetail(articles[index].id)),
            ),
          ),
        ),
      ),
    );
  }
}
