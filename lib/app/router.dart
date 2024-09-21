import 'package:auto_route/auto_route.dart';
import 'package:sheet/route.dart';
import 'package:ziggle/app/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Layout,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(
        path: '/',
        page: ZiggleBottomNavigationRoute.page,
        children: [
          RedirectRoute(path: '', redirectTo: 'feed'),
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
            customRouteBuilder: <T>(_, child, page) =>
                MaterialExtendedPageRoute<T>(
              fullscreenDialog: page.fullscreenDialog,
              settings: page,
              builder: (context) => child,
              maintainState: page.maintainState,
            ),
          ),
          CustomRoute(
            page: NoticeWriteSheetShellRoute.page,
            customRouteBuilder: <T>(_, child, page) => CupertinoSheetRoute<T>(
              settings: page,
              builder: (context) => child,
              maintainState: page.maintainState,
            ),
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
      AutoRoute(
        path: '/notice/:id',
        page: SingleNoticeShellRoute.page,
        children: [
          AutoRoute(path: '', page: DetailRoute.page),
          AutoRoute(
            path: 'edit',
            page: NoticeEditShellRoute.page,
            children: [
              AutoRoute(path: '', page: NoticeEditRoute.page),
              AutoRoute(path: 'body', page: NoticeEditBodyRoute.page),
              AutoRoute(
                path: 'additional',
                page: WriteAdditionalNoticeRoute.page,
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
}
