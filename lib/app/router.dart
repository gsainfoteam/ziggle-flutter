import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sheet/route.dart';
import 'package:ziggle/app/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Layout,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes {
    return [
      RedirectRoute(path: '/', redirectTo: '/splash'),
      AutoRoute(path: '/splash', page: SplashRoute.page),
      AutoRoute(
        path: '/',
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
          AutoRoute(
            path: '',
            page: NoticeWriteBodyRoute.page,
          ),
          CustomRoute(
            path: 'config',
            page: NoticeWriteConfigRoute.page,
            customRouteBuilder: _extendedRoute,
          ),
          CustomRoute(
            page: NoticeWriteSheetShellRoute.page,
            customRouteBuilder: _sheetRoute,
            children: [
              AutoRoute(
                path: 'tags',
                page: NoticeWriteSelectTagsRoute.page,
              ),
              AutoRoute(
                path: 'preview',
                page: NoticeWritePreviewRoute.page,
              ),
              AutoRoute(
                path: 'consent',
                page: NoticeWriteConsentRoute.page,
              ),
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
      AutoRoute(
        path: '/group/create',
        page: GroupCreationShellRoute.page,
        children: [
          AutoRoute(
            path: ':step',
            page: GroupCreationProfileRoute.page,
          ),
          AutoRoute(
            path: 'introduce',
            page: GroupCreationIntroduceRoute.page,
          ),
          AutoRoute(
            path: 'notion',
            page: GroupCreationNotionRoute.page,
          ),
          AutoRoute(
            path: 'done',
            page: GroupCreationDoneRoute.page,
          ),
        ],
      ),
    ];
  }

  Route<T> _sheetRoute<T>(
          BuildContext _, Widget child, AutoRoutePage<T> page) =>
      CupertinoSheetRoute<T>(
        settings: page,
        builder: (context) => child,
        maintainState: page.maintainState,
      );

  Route<T> _extendedRoute<T>(
          BuildContext _, Widget child, AutoRoutePage<T> page) =>
      MaterialExtendedPageRoute<T>(
        fullscreenDialog: page.fullscreenDialog,
        settings: page,
        builder: (context) => child,
        maintainState: page.maintainState,
      );
}
