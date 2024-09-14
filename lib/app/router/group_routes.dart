part of 'routes.dart';

@TypedShellRoute<GroupCreationShellRoute>(
    routes: [TypedGoRoute<GroupCreationRoute>(path: '/group/create/:step')])
class GroupCreationShellRoute extends ShellRouteData {
  @override
  Widget builder(context, state, navigator) {
    return navigator;
  }
}

class GroupCreationRoute extends GoRouteData {
  const GroupCreationRoute([this.step = GroupCreationStep.profile]);
  final GroupCreationStep step;

  @override
  Widget build(context, state) {
    final screen = {
      GroupCreationStep.profile: const GroupCreationProfilePage(),
      GroupCreationStep.introduce: const GroupCreationIntroducePage(),
      GroupCreationStep.notion: const GroupCreationNotionPage(),
      GroupCreationStep.done: const GroupCreationDonePage(),
    }[step];
    return GroupCreationLayout(
      step: step,
      child: screen ?? const SizedBox.shrink(),
    );
  }
}
part of 'routes.dart';

@TypedGoRoute<GroupRoute>(path: '/group')
class GroupRoute extends GoRouteData {
  const GroupRoute();
  @override
  Widget build(context, state) => const GroupManagementMainPage();
}
