part of 'routes.dart';

@TypedStatefulShellRoute<MainShellRoute>(branches: [
  TypedStatefulShellBranch(
    routes: [TypedGoRoute<FeedRoute>(path: '/')],
  ),
  TypedStatefulShellBranch(
    routes: [TypedGoRoute<CategoryRoute>(path: '/category')],
  ),
  TypedStatefulShellBranch(
    routes: [TypedGoRoute<FavoriteRoute>(path: '/favorite')],
  ),
  TypedStatefulShellBranch(
    routes: [TypedGoRoute<ProfileRoute>(path: '/profile')],
  ),
])
class MainShellRoute extends StatefulShellRouteData {
  const MainShellRoute();

  @override
  Page<void> pageBuilder(context, state, navigationShell) => MaterialPage(
        key: state.pageKey,
        child: ZiggleBottomNavigationPage(
          items: [
            BottomNavigationBarItem(
              icon: Assets.icons.feed.svg(),
              activeIcon: Assets.icons.feedActive.svg(),
            ),
            BottomNavigationBarItem(
              icon: Assets.icons.category.svg(),
              activeIcon: Assets.icons.categoryActive.svg(),
            ),
            BottomNavigationBarItem(
              icon: Assets.icons.favorite.svg(),
              activeIcon: Assets.icons.favoriteActive.svg(),
            ),
            BottomNavigationBarItem(
              icon: Assets.icons.profile.svg(),
              activeIcon: Assets.icons.profileActive.svg(),
            ),
          ],
          child: navigationShell,
        ),
      );
}

class FeedRoute extends GoRouteData {
  const FeedRoute();
  @override
  Widget build(context, state) => const FeedPage();
}

class CategoryRoute extends GoRouteData {
  const CategoryRoute();
  @override
  Widget build(context, state) => const CategoryPage();
}

class FavoriteRoute extends GoRouteData {
  const FavoriteRoute();
  @override
  Widget build(context, state) => const FeedPage();
}

class ProfileRoute extends GoRouteData {
  const ProfileRoute();
  @override
  Widget build(context, state) => const ProfilePage();
}
