import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/group_creation_done_page.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/group_creation_introduce_page.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/group_creation_notion_page.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/group_creation_profile_page.dart';
import 'package:ziggle/app/modules/groups/presentation/widgets/group_creation_layout.dart';
import 'package:ziggle/app/modules/notice/presentation/pages/notice_write_body_page.dart';
import 'package:ziggle/app/modules/notice/presentation/pages/notice_write_config_page.dart';
import 'package:ziggle/app/modules/splash/presentation/pages/splash_page.dart';
import 'package:ziggle/gen/strings.g.dart';

part 'group_routes.dart';
part 'notice_routes.dart';
part 'routes.g.dart';
part 'splash_routes.dart';

abstract class AppRoutes {
  AppRoutes._();

  static final config = GoRouter(
    initialLocation: const SplashRoute().location,
    routes: $appRoutes,
  );
}

extension GoRouterExtension on GoRouter {
  void popUntilPath(String ancestorPath) async {
    final match = routerDelegate.currentConfiguration.matches.last;
    if (match is ImperativeRouteMatch) {
      if (match.matches.last.matchedLocation == ancestorPath) return;
    } else {
      if (match.matchedLocation == ancestorPath) return;
    }
    pop();
    popUntilPath(ancestorPath);
  }
}

extension BuildContextX on BuildContext {
  void popUntilPath(String ancestorPath) =>
      GoRouter.of(this).popUntilPath(ancestorPath);
}
