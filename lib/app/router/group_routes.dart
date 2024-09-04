part of 'routes.dart';

@TypedShellRoute<GroupCreationShellRoute>(
  routes: [TypedGoRoute<GroupCreationRoute>(path: '/group/create/:step')],
)
class GroupCreationShellRoute extends ShellRouteData {
  const GroupCreationShellRoute();

  @override
  Widget builder(context, state, navigator) => PopScope(
        canPop: GoRouter.of(context).canPopInShellRoute,
        child: navigator,
      );
}

class GroupCreationRoute extends GoRouteData {
  const GroupCreationRoute([this.step = GroupCreationStage.profile]);

  final GroupCreationStage step;

  @override
  Widget build(context, state) {
    final screen = {
      GroupCreationStage.profile: const GroupCreationProfilePage(),
      GroupCreationStage.introduce: const GroupCreationIntroducePage(),
    }[step];
    return GroupCreationLayout(
      stage: step,
      child: screen ?? const SizedBox.shrink(),
    );
  }
}
