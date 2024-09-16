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

@TypedGoRoute<GroupManagementRoute>(path: '/group/management')
class GroupManagementRoute extends GoRouteData {
  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(context, state) {
    return const GroupManagementChangeBriefDescriptionPage();
  }
}

@TypedGoRoute<GroupManagementNameRoute>(path: '/group/management/name')
class GroupManagementNameRoute extends GoRouteData {
  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(context, state) {
    return const GroupManagementChangeNamePage();
  }
}

final groupManagementRoutes = GoRouter(
  routes: [
    GoRoute(
      path: '/group/management',
      builder: (context, state) => const GroupManagementPage(),
      routes: [
        GoRoute(
          path: 'change-group-name',
          builder: (context, state) => const GroupManagementChangeNamePage(),
        ),
        GoRoute(
          path: 'change-group-description',
          builder: (context, state) =>
              const GroupManagementChangeBriefDescriptionPage(),
        ),
        GoRoute(
          path: 'change-invitation-link',
          builder: (context, state) =>
              const GroupManagementInvitatoinLinkPage(),
        ),
      ],
    ),
  ],
);
