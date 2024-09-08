part of 'routes.dart';

@TypedShellRoute<GroupCreationShellRoute>(
    routes: [TypedGoRoute<GroupCreationRoute>(path: '/group/create/:step')])
class GroupCreationShellRoute extends ShellRouteData {
  @override
  Widget builder(context, state, navigator) {
    return PopScope(
      canPop: GoRouter.of(context).canPopInShellRoute,
      child: navigator,
    );
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
    }[step];
    return GroupCreationLayout(
      step: step,
      child: screen ?? const SizedBox.shrink(),
    );
  }
}
