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

@TypedGoRoute<NoticeRoute>(path: '/notice/:id')
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
