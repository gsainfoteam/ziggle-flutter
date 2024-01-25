library routes;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/modules/auth/presentation/pages/auth_required_page.dart';
import 'package:ziggle/app/modules/auth/presentation/pages/profile_page.dart';
import 'package:ziggle/app/modules/notices/data/models/notice_model.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/feed_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/notice_list_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/notice_page.dart';
import 'package:ziggle/app/modules/setting/presentation/pages/about_page.dart';
import 'package:ziggle/app/modules/setting/presentation/pages/feedback_page.dart';
import 'package:ziggle/app/modules/setting/presentation/pages/license_page.dart';
import 'package:ziggle/app/modules/setting/presentation/pages/packages_page.dart';
import 'package:ziggle/app/modules/setting/presentation/pages/setting_page.dart';
import 'package:ziggle/app/modules/splash/presentation/pages/splash_page.dart';

part 'auth_routes.dart';
part 'notice_routes.dart';
part 'routes.g.dart';
part 'setting_routes.dart';
part 'splash_routes.dart';

abstract class AppRoutes {
  static final config = GoRouter(
    initialLocation: const SplashRoute().location,
    debugLogDiagnostics: kDebugMode,
    routes: $appRoutes,
  );
}
