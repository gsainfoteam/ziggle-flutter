part of 'routes.dart';

@TypedGoRoute<GroupRoute>(path: '/group')
class GroupRoute extends GoRouteData {
  const GroupRoute();
  @override
  Widget build(context, state) => const GroupManagementMainPage();
}
