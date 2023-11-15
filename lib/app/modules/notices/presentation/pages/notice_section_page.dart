import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notices/notices_bloc.dart';

import '../../domain/entities/notice_search_query_entity.dart';
import '../../domain/enums/notice_mine.dart';
import '../../domain/enums/notice_type.dart';

// class NoticeSectionPage extends StatefulWidget {
//   final NoticeType type;
//   const NoticeSectionPage({super.key, required this.type});

//   @override
//   State<NoticeSectionPage> createState() => _NoticeSectionPageState();
// }

// typedef _GroupNotice = MapEntry<DateTime, List<NoticeSummaryEntity>>;

// class _NoticeSectionPageState extends State<NoticeSectionPage> {
//   final articleController =
//       PagingController<int, NoticeSummaryEntity>(firstPageKey: 1);
//   final groupArticleController =
//       PagingController<int, _GroupNotice>(firstPageKey: 1);

//   @override
//   void dispose() {
//     articleController.dispose();
//     groupArticleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.type.title)),
//       body: RefreshIndicator.adaptive(
//         onRefresh: () async {
//           widget.type == NoticeType.deadline
//               ? groupArticleController.refresh()
//               : articleController.refresh();
//         },
//         child: CustomScrollView(
//           slivers: [
//             SliverToBoxAdapter(
//               child: Column(
//                 children: [
//                   Text(widget.type.emoji,
//                       style: const TextStyle(fontSize: 140)),
//                   Text(widget.type.title, style: TextStyles.articleTitleStyle),
//                   Text(
//                     widget.type.description,
//                     textAlign: TextAlign.center,
//                     style: TextStyles.articleCardAuthorStyle,
//                   ),
//                   const SizedBox(height: 50),
//                 ],
//               ),
//             ),
//             SliverPadding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               sliver: widget.type == NoticeType.deadline
//                   ? _buildDeadlineList()
//                   : _buildSimpleList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDeadlineList() {
//     return PagedSliverList<int, _GroupNotice>.separated(
//       pagingController: groupArticleController,
//       separatorBuilder: (context, index) => const SizedBox(height: 18),
//       builderDelegate: PagedChildBuilderDelegate(
//         firstPageProgressIndicatorBuilder: (_) => const _ProgressIndicator(),
//         newPageProgressIndicatorBuilder: (_) => const _ProgressIndicator(),
//         noItemsFoundIndicatorBuilder: (_) => const _NoItemsFoundIndicator(),
//         itemBuilder: (context, item, index) => Column(
//           children: [
//             Text(
//               t.article.deadlineDelta(
//                 n: calculateDateDelta(DateTime.now(), item.key),
//               ),
//               style: TextStyles.articleCardTitleStyle,
//             ),
//             const SizedBox(height: 12),
//             Container(width: 80, height: 1, color: Palette.black),
//             ListView(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               children: item.value
//                   .map(
//                     (article) => Padding(
//                       padding: const EdgeInsets.only(bottom: 18),
//                       child: NoticeCard(
//                         notice: article,
//                         direction: Axis.horizontal,
//                         onTap: () =>
//                             context.push(Paths.articleDetail, extra: article),
//                       ),
//                     ),
//                   )
//                   .toList(),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSimpleList() {
//     return PagedSliverList<int, NoticeSummaryEntity>.separated(
//       pagingController: articleController,
//       separatorBuilder: (context, index) => const SizedBox(height: 18),
//       builderDelegate: PagedChildBuilderDelegate(
//         firstPageProgressIndicatorBuilder: (_) => const _ProgressIndicator(),
//         newPageProgressIndicatorBuilder: (_) => const _ProgressIndicator(),
//         noItemsFoundIndicatorBuilder: (_) => const _NoItemsFoundIndicator(),
//         itemBuilder: (context, item, index) => NoticeCard(
//           notice: item,
//           direction: Axis.horizontal,
//           onTap: () => context.push(Paths.articleDetail, extra: item),
//         ),
//       ),
//     );
//   }
// }

// class _NoItemsFoundIndicator extends StatelessWidget {
//   const _NoItemsFoundIndicator();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Assets.images.noResult.image(width: 160),
//         const SizedBox(height: 16),
//         Text(t.search.noResult, style: TextStyles.secondaryLabelStyle),
//       ],
//     );
//   }
// }

// class _ProgressIndicator extends StatelessWidget {
//   const _ProgressIndicator();

//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.symmetric(vertical: 16),
//       child: Center(child: CircularProgressIndicator.adaptive()),
//     );
//   }
// }
class NoticeSectionPage extends StatelessWidget {
  final NoticeType type;
  const NoticeSectionPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<NoticesBloc>()),
      ],
      child: _Layout(type: type),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout({required this.type});

  final NoticeType type;

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.type.title)),
      body: RefreshIndicator.adaptive(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          final bloc = context.read<NoticesBloc>();
          bloc.add(NoticesEvent.fetch(
            NoticeSearchQueryEntity(
              tags: widget.type.isSearchable ? [widget.type.name] : null,
              orderBy: widget.type.sort,
              my: widget.type.mine,
            ),
          ));
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Text(widget.type.emoji,
                      style: const TextStyle(fontSize: 140)),
                  Text(widget.type.title, style: TextStyles.articleTitleStyle),
                  Text(
                    widget.type.description,
                    textAlign: TextAlign.center,
                    style: TextStyles.articleCardAuthorStyle,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
