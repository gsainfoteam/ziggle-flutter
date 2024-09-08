import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/modules/splash/presentation/pages/splash_page.dart';

part 'routes.g.dart';
part 'splash_routes.dart';

abstract class AppRoutes {
  AppRoutes._();

  static final config = GoRouter(
    initialLocation: const SplashRoute().location,
    routes: $appRoutes,
  );
}
