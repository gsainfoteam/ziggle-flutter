import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sheet/route.dart';
import 'package:ziggle/app/modules/common/presentation/pages/ziggle_bottom_navigation_page.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/group_creation_done_page.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/group_creation_introduce_page.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/group_creation_notion_page.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/group_creation_profile_page.dart';
import 'package:ziggle/app/modules/groups/presentation/widgets/group_creation_layout.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/category_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/detail_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/feed_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/list_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/notice_write_body_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/notice_write_config_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/notice_write_consent_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/notice_write_preview_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/notice_write_select_tags_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/search_page.dart';
import 'package:ziggle/app/modules/splash/presentation/pages/splash_page.dart';
import 'package:ziggle/app/modules/user/presentation/pages/profile_page.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

part 'group_routes.dart';
part 'main_routes.dart';
part 'notice_routes.dart';
part 'routes.g.dart';
part 'splash_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

abstract class AppRoutes {
  AppRoutes._();

  static final config = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: const SplashRoute().location,
    routes: $appRoutes,
    debugLogDiagnostics: kDebugMode,
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
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/modules/notice/presentation/pages/group_management_main_page.dart';
import 'package:ziggle/app/modules/splash/presentation/pages/splash_page.dart';

part 'routes.g.dart';
part 'splash_routes.dart';
part 'group_routes.dart';

abstract class AppRoutes {
  AppRoutes._();

  static final config = GoRouter(
    initialLocation: const SplashRoute().location,
    routes: $appRoutes,
  );
}
