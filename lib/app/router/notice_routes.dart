part of 'routes.dart';

@TypedGoRoute<FeedRoute>(path: '/')
class FeedRoute extends GoRouteData {
  const FeedRoute();
  @override
  Widget build(context, state) => const FeedPage();
}

@TypedGoRoute<SectionRoute>(path: '/section/:type')
class SectionRoute extends GoRouteData {
  const SectionRoute({required this.type});
  final NoticeType type;
  @override
  Widget build(context, state) => NoticeListPage(type: type);
}

@TypedGoRoute<NoticeRoute>(
  path: '/notice/:id',
  routes: [
    TypedGoRoute<WriteForeignRoute>(path: 'foreign'),
  ],
)
class NoticeRoute extends GoRouteData {
  const NoticeRoute({required this.id, this.$extra});
  factory NoticeRoute.fromEntity(NoticeEntity notice) => NoticeRoute(
        id: notice.id,
        $extra: NoticeModel.fromEntity(notice).toJson(),
      );
  final int id;
  final Map<String, dynamic>? $extra;

  @override
  Widget build(context, state) => NoticePage(
        notice: $extra != null
            ? NoticeModel.fromJson($extra!)
            : NoticeEntity.fromId(id),
      );
}

class WriteForeignRoute extends GoRouteData {
  const WriteForeignRoute({required this.id, required this.$extra});
  factory WriteForeignRoute.fromEntity(NoticeEntity notice) =>
      WriteForeignRoute(
        id: notice.id,
        $extra: NoticeModel.fromEntity(notice).toJson(),
      );

  final int id;
  final Map<String, dynamic> $extra;

  @override
  Widget build(context, state) => AuthRequiredPage(
        child: WriteForeignPage(notice: NoticeModel.fromJson($extra)),
      );
}

@TypedGoRoute<SearchRoute>(path: '/search')
class SearchRoute extends GoRouteData {
  const SearchRoute();
  @override
  Widget build(context, state) => const SearchPage();
}

@TypedGoRoute<WriteRoute>(
  path: '/write',
  routes: [TypedGoRoute<WriteArticleRoute>(path: 'article')],
)
class WriteRoute extends GoRouteData {
  const WriteRoute();
  @override
  Widget build(context, state) => const AuthRequiredPage(child: WritePage());
}

class WriteArticleRoute extends GoRouteData {
  @Deprecated('Use WriteArticleRoute.create instead')
  const WriteArticleRoute({required this.$extra});
  factory WriteArticleRoute.create({
    required String title,
    required String hint,
    required String? body,
  }) {
    // ignore: deprecated_member_use_from_same_package
    return WriteArticleRoute(
      $extra: {'title': title, 'hint': hint, 'body': body ?? ''},
    );
  }
  final Map<String, dynamic> $extra;
  @override
  Widget build(context, state) => AuthRequiredPage(
        child: WriteArticlePage(
          title: $extra['title'],
          hintText: $extra['hint'],
          initialContent: $extra['body'],
        ),
      );
}
