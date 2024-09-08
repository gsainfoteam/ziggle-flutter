import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
<<<<<<< HEAD
import 'package:ziggle/app/modules/notice/presentation/pages/group_management_main_page.dart';
=======
>>>>>>> 218915a (chore(deps): add go_router (#324))
import 'package:ziggle/app/modules/splash/presentation/pages/splash_page.dart';

part 'routes.g.dart';
part 'splash_routes.dart';
<<<<<<< HEAD
part 'group_routes.dart';
=======
>>>>>>> 218915a (chore(deps): add go_router (#324))

abstract class AppRoutes {
  AppRoutes._();

  static final config = GoRouter(
    initialLocation: const SplashRoute().location,
    routes: $appRoutes,
  );
}
