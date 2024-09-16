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

@TypedGoRoute<GroupManagementRoute>(
  path: '/group/management',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<GroupNameManagementRoute>(path: 'name'),
    TypedGoRoute<GroupDescriptionManagementRoute>(path: 'description'),
    TypedGoRoute<GroupNotionLinkManagementRoute>(path: 'notion-link'),
    TypedGoRoute<GroupInvitationLinkManagementRoute>(path: 'invitation-link'),
    TypedGoRoute<GroupMemberManagementRoute>(path: 'member')
  ],
)
class GroupManagementRoute extends GoRouteData {
  const GroupManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GroupManagementPage();
  }
}

class GroupNameManagementRoute extends GoRouteData {
  const GroupNameManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GroupNameManagementPage();
  }
}

class GroupDescriptionManagementRoute extends GoRouteData {
  const GroupDescriptionManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GroupDescriptionManagementPage();
  }
}

class GroupNotionLinkManagementRoute extends GoRouteData {
  const GroupNotionLinkManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GroupNotionLinkManagementPage();
  }
}

class GroupInvitationLinkManagementRoute extends GoRouteData {
  const GroupInvitationLinkManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GroupInvitationLinkManagementPage();
  }
}

class GroupMemberManagementRoute extends GoRouteData {
  const GroupMemberManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GroupMemberManagementPage();
  }
}
