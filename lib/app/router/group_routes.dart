part of 'routes.dart';

@TypedGoRoute<GroupDetailRoute>(path: '/group/detail')
class GroupDetailRoute extends GoRouteData {
  const GroupDetailRoute();

  @override
  Widget build(context, state) => const GroupDetailPage();
}
