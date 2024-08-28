part of 'routes.dart';

@TypedGoRoute<GroupCreationRoute>(path: '/group/create')
class GroupCreationRoute extends GoRouteData {
  const GroupCreationRoute();
  @override
  Widget build(context, state) => const GroupCreationPage();
}
