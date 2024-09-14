part of 'routes.dart';

@TypedGoRoute<NoticeDetailRoute>(path: '/notice/:id')
class NoticeDetailRoute extends GoRouteData {
  const NoticeDetailRoute({required this.id, this.$extra});
  factory NoticeDetailRoute.fromSummary(NoticeEntity summary) =>
      NoticeDetailRoute(
        id: summary.id,
      );

  final int id;
  final Map<String, dynamic>? $extra;
  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) => DetailPage(
        notice: NoticeEntity.mock(
          content: '공지 내용',
          title: '공지 제목',
          deadline: DateTime(2024, 9, 14, 0, 48, 20),
          imageUrls: [
            'https://picsum.photos/200/300',
            'https://picsum.photos/200/111',
            'https://picsum.photos/200/302',
          ],
          authorName: '홍길동',
          createdAt: DateTime.now(),
          tags: ['태그1', '태그2'],
        ),
      );
}

@TypedGoRoute<SearchRoute>(path: '/search')
class SearchRoute extends GoRouteData {
  const SearchRoute();
  static final $parentNavigatorKey = rootNavigatorKey;
  @override
  Widget build(context, state) => const SearchPage();
}

@TypedGoRoute<NoticeCategoryRoute>(path: '/category/:type')
class NoticeCategoryRoute extends GoRouteData {
  const NoticeCategoryRoute(this.type);

  final NoticeType type;
  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(context, state) => ListPage(title: type.name, type: type);
}

@TypedShellRoute<NoticeShellRoute>(routes: [
  TypedGoRoute<NoticeWriteBaseRoute>(path: '/write'),
  TypedGoRoute<NoticeWriteRoute>(path: '/write/:step'),
  TypedGoRoute<NoticeWriteSheetRoute>(path: '/write/sheet/:step'),
])
class NoticeShellRoute extends ShellRouteData {
  @override
  Widget builder(context, state, navigator) => navigator;
}

class NoticeWriteBaseRoute extends GoRouteData {
  const NoticeWriteBaseRoute();
  @override
  FutureOr<String?> redirect(context, state) =>
      const NoticeWriteRoute().location;
}

enum NoticeWriteStep { body, config }

class NoticeWriteRoute extends GoRouteData {
  const NoticeWriteRoute([this.step = NoticeWriteStep.body]);

  final NoticeWriteStep step;

  @override
  Page<void> buildPage(context, state) {
    final page = {
          NoticeWriteStep.body: const NoticeWriteBodyPage(),
          NoticeWriteStep.config: const NoticeWriteConfigPage(),
        }[step] ??
        const SizedBox.shrink();
    return MaterialExtendedPage(child: page);
  }
}

enum NoticeWriteSheetStep { tags, preview, consent }

class NoticeWriteSheetRoute extends GoRouteData {
  const NoticeWriteSheetRoute(this.step);

  final NoticeWriteSheetStep step;

  @override
  Page<void> buildPage(context, state) {
    final page = {
          NoticeWriteSheetStep.tags: const NoticeWriteSelectTagsPage(),
          NoticeWriteSheetStep.preview: const NoticeWritePreviewPage(),
          NoticeWriteSheetStep.consent: const NoticeWriteConsentPage(),
        }[step] ??
        const SizedBox.shrink();
    return CupertinoSheetPage(
      key: state.pageKey,
      child: page,
    );
  }
}
