import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/modules/auth/presentation/pages/profile_page.dart';
import 'package:ziggle/app/modules/notices/data/models/notice_model.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/feed_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/notice_page.dart';
import 'package:ziggle/app/modules/splash/presentation/pages/splash_page.dart';

part 'routes.g.dart';

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData {
  const SplashRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashPage();
}

@TypedGoRoute<FeedRoute>(path: '/')
class FeedRoute extends GoRouteData {
  const FeedRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const FeedPage();
}

@TypedGoRoute<NoticeRoute>(path: '/notice/:id')
class NoticeRoute extends GoRouteData {
  const NoticeRoute({required this.id, this.$extra});
  factory NoticeRoute.fromEntity(NoticeEntity notice) => NoticeRoute(
        id: notice.id,
        $extra: NoticeModel.fromEntity(notice).toJson(),
      );
  final int id;
  final Map<String, dynamic>? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) => NoticePage(
        notice: $extra != null
            ? NoticeModel.fromJson($extra!)
            : NoticeEntity.fromId(id),
      );
}

@TypedGoRoute<MyPageRoute>(path: '/mypage')
class MyPageRoute extends GoRouteData {
  const MyPageRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfilePage();
}

abstract class AppRoutes {
  static final config = GoRouter(
    initialLocation: const SplashRoute().location,
    debugLogDiagnostics: kDebugMode,
    routes: $appRoutes,
  );
}
