import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart' hide CupertinoSheetRoute;
import 'package:sheet/route.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/auth_bloc.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:ziggle/app/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Layout,Route')
class AppRouter extends RootStackRouter {
  /// 스플래시를 최소한 이만큼은 보여 줘서 로고가 깜빡이고 사라지지 않게 한다.
  static const splashMinimum = Duration(seconds: 1);

  Timer? _splashTimer;
  bool _splashMinimumPassed = false;

  /// 스플래시를 벗어났는지. 그 전에 들어온 링크는 [_pendingLink]에 둔다.
  bool _splashLeft = false;
  String? _pendingLink;

  /// 들어온 링크를 연다. 링크는 이 함수에서만 열어서 같은 링크를 두 번 열지
  /// 않는다.
  ///
  /// 스플래시 위에 바로 열면, 스플래시를 벗어날 때 홈으로 바꾸면서 그 화면도
  /// 사라지므로 다시 열어야 한다. 그래서 스플래시 중에는 링크를 보관했다가
  /// 홈으로 이동한 뒤에 한 번만 연다.
  void openLink(String link) {
    if (!_splashLeft) {
      _pendingLink = link;
      return;
    }
    _pushLink(link);
  }

  Future<void> _pushLink(String link) async {
    try {
      // 링크 화면을 닫을 때 끝난다. 부르는 쪽은 기다리지 않는다.
      await pushPath(link);
    } catch (_) {}
  }

  @override
  List<AutoRouteGuard> get guards => [
    AutoRouteGuard.simple((resolver, router) async {
      final context = router.navigatorKey.currentContext;
      if (resolver.routeName == SplashRoute.name) {
        return _guardSplash(resolver, router);
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

  /// 스플래시에서 벗어나는 이동은 이 가드만 한다. (#721)
  ///
  /// 예전에는 SplashPage가 프로필 로딩을 기다렸다가 직접 홈으로 이동했다.
  /// 그런데 같은 상태 변화로 `reevaluateListenable`이 가드 재평가도 시작한다.
  /// 재평가는 스택을 비운 뒤 스플래시를 비동기로 다시 넣는데, 그 사이에
  /// SplashPage의 `replaceAll`이 끼어들면 스택이 `[홈, 스플래시]`가 되어
  /// 스플래시에서 멈춘 것처럼 보였다.
  ///
  /// 이 가드는 재평가를 포함해 스플래시가 스택에 들어갈 때마다 실행되므로,
  /// 준비가 끝난 뒤에는 스플래시가 다시 올라올 수 없다.
  void _guardSplash(NavigationResolver resolver, StackRouter router) {
    // 스플래시는 스택의 맨 아래에만 둔다. `/`로 가는 링크(예: 푸시 알림의
    // path)는 실행 중인 앱 위에 스플래시를 다시 넣으려 하는데, 이때는 그대로 둔다.
    // 앱을 켤 때와 가드 재평가 중에는 스택이 비어 있다.
    if (router.stack.isNotEmpty) return resolver.next(false);
    _splashTimer ??= Timer(splashMinimum, () {
      _splashMinimumPassed = true;
      // 최소 시간이 지나기를 기다리던 스플래시를 다시 확인한다.
      if (stack.any((page) => page.routeData.name == SplashRoute.name)) {
        reevaluateGuards();
      }
    });
    // 로그인 상태와 프로필이 바뀌면 `reevaluateListenable`이 다시 확인한다.
    final ready =
        !sl<AuthBloc>().state.isLoading && sl<UserBloc>().state.isLoaded;
    if (!ready || !_splashMinimumPassed) return resolver.next(true);
    resolver.next(false);
    _leaveSplash(router);
  }

  void _leaveSplash(StackRouter router) {
    // `replaceAll`이 돌려주는 Future는 홈을 닫을 때 끝나므로 기다리지 않는다.
    // 로그인이나 동의가 필요하면 홈의 가드가 그 화면으로 보낸다.
    unawaited(router.replaceAll([FeedRoute()]));
    _splashLeft = true;
    final link = _pendingLink;
    _pendingLink = null;
    if (link == null) return;
    // 홈이 스택에 들어간 뒤에 연다. 로그인이나 동의 화면으로 갔다면 열지 않는다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final top = stack.lastOrNull?.routeData.name;
      if (top == ZiggleBottomNavigationRoute.name) _pushLink(link);
    });
  }

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
