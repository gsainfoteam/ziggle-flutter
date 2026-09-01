import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart' hide CupertinoSheetRoute;
import 'package:sheet/route.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/auth_bloc.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:ziggle/app/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Layout,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRouteGuard> get guards => [
    AutoRouteGuard.simple((resolver, router) async {
      final context = router.navigatorKey.currentContext;
      if (resolver.routeName == SplashRoute.name) {
        return resolver.next(true);
      }
      // 로그인 여부는 토큰으로 판단한다. 프로필(user)이 없다고 해서
      // 비로그인인 것은 아니다 - 미동의 유저는 로그인 상태이지만 프로필이 없다.
      final authenticated = sl<AuthBloc>().state.hasUser;
      if (!authenticated) {
        if (resolver.routeName == LoginRoute.name) {
          return resolver.next(true);
        }
        router.push(LoginRoute());
        return resolver.next(false);
      }
      final userState = sl<UserBloc>().state;
      // 프로필 조회 결과를 아직 못 받았으면 판단을 미룬다.
      if (!userState.isLoaded) {
        return resolver.next(false);
      }
      final user = userState.user;
      final consented = user?.hasConsented ?? false;
      if (!consented) {
        if (resolver.routeName == ConsentRoute.name ||
            resolver.routeName == WithdrawRoute.name) {
          return resolver.next(true);
        }
        router.push(ConsentRoute());
        return resolver.next(false);
      }
      if ([LoginRoute.name, ConsentRoute.name].contains(resolver.routeName)) {
        resolver.next(false);
        context?.router.replaceAll([FeedRoute()]);
        return;
      }
      return resolver.next(true);
    }),
  ];

  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(path: '/', page: SplashRoute.page),
      AutoRoute(path: '/login', page: LoginRoute.page),
      AutoRoute(path: '/consent', page: ConsentRoute.page),
      AutoRoute(path: '/withdraw', page: WithdrawRoute.page),
      AutoRoute(
        path: '/home',
        page: ZiggleBottomNavigationRoute.page,
        children: [
          AutoRoute(path: 'feed', page: FeedRoute.page),
          AutoRoute(path: 'category', page: CategoryRoute.page),
          AutoRoute(path: 'mypage', page: ProfileRoute.page),
        ],
      ),
      AutoRoute(path: '/setting', page: SettingRoute.page),
      AutoRoute(path: '/setting/information', page: InformationRoute.page),
      AutoRoute(
        path: '/setting/information/packages',
        page: PackagesRoute.page,
      ),
      AutoRoute(
        path: '/setting/information/packages/:package',
        page: PackageLicensesRoute.page,
      ),
      AutoRoute(
        path: '/write',
        page: NoticeWriteShellRoute.page,
        children: [
          AutoRoute(path: '', page: NoticeWriteBodyRoute.page),
          CustomRoute(
            path: 'config',
            page: NoticeWriteConfigRoute.page,
            customRouteBuilder: _extendedRoute,
          ),
          CustomRoute(
            page: NoticeWriteSheetShellRoute.page,
            customRouteBuilder: _sheetRoute,
            children: [
              AutoRoute(path: 'tags', page: NoticeWriteSelectTagsRoute.page),
              AutoRoute(path: 'preview', page: NoticeWritePreviewRoute.page),
              AutoRoute(path: 'consent', page: NoticeWriteConsentRoute.page),
            ],
          ),
        ],
      ),
      AutoRoute(path: '/:type', page: ListRoute.page),
      AutoRoute(
        path: '/notice/:id',
        page: SingleNoticeShellRoute.page,
        children: [
          AutoRoute(path: '', page: DetailRoute.page),
          AutoRoute(
            path: 'edit',
            page: NoticeEditShellRoute.page,
            children: [
              CustomRoute(
                path: '',
                page: NoticeEditRoute.page,
                customRouteBuilder: _extendedRoute,
              ),
              AutoRoute(path: 'body', page: NoticeEditBodyRoute.page),
              AutoRoute(
                path: 'additional',
                page: WriteAdditionalNoticeRoute.page,
              ),
              CustomRoute(
                path: 'preview',
                page: NoticeEditPreviewRoute.page,
                customRouteBuilder: _sheetRoute,
              ),
            ],
          ),
        ],
      ),
      AutoRoute(path: '/search', page: SearchRoute.page),
    ];
  }

  Route<T> _sheetRoute<T>(
    BuildContext _,
    Widget child,
    AutoRoutePage<T> page,
  ) => CupertinoSheetRoute<T>(
    settings: page,
    builder: (context) => child,
    maintainState: page.maintainState,
  );

  Route<T> _extendedRoute<T>(
    BuildContext _,
    Widget child,
    AutoRoutePage<T> page,
  ) => MaterialExtendedPageRoute<T>(
    fullscreenDialog: page.fullscreenDialog,
    settings: page,
    builder: (context) => child,
    maintainState: page.maintainState,
  );
}
