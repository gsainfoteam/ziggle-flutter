import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/group_creation_introduce_page.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/group_creation_profile_page.dart';
import 'package:ziggle/app/modules/groups/presentation/widgets/group_creation_layout.dart';
import 'package:ziggle/app/modules/splash/presentation/pages/splash_page.dart';
import 'package:ziggle/gen/strings.g.dart';

part 'group_routes.dart';
part 'routes.g.dart';
part 'splash_routes.dart';

abstract class AppRoutes {
  AppRoutes._();

  static final config = GoRouter(
    initialLocation: const SplashRoute().location,
    routes: $appRoutes,
  );
}

extension _GoRouterX on GoRouter {
  bool get canPopInShellRoute {
    final conf = routerDelegate.currentConfiguration;
    final lastMatch = conf.matches.lastOrNull;
    return lastMatch is ShellRouteMatch ? lastMatch.matches.length == 1 : true;
  }
}
