import 'package:auto_route/auto_route.dart';
import 'package:ziggle/app/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/', page: ZiggleBottomNavigationRoute.page, children: [
          RedirectRoute(path: '', redirectTo: 'feed'),
          AutoRoute(path: 'feed', page: FeedRoute.page),
          AutoRoute(path: 'category', page: CategoryRoute.page),
          AutoRoute(path: 'feed', page: FeedRoute.page),
        ]),
      ];
}
