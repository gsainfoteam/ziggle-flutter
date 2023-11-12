import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/modules/auth/presentation/pages/login_page.dart';
import 'package:ziggle/app/modules/auth/presentation/pages/splash_page.dart';

part 'paths.dart';

abstract class Routes {
  Routes._();

  static final config = GoRouter(
    initialLocation: _Paths.splash,
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        path: _Paths.splash,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: _Paths.login,
        builder: (_, __) => const LoginPage(),
      ),
    ],
  );

  // static final routes = [
  //   GetPage(
  //     name: _Paths.SPLASH,
  //     page: () => const SplashPage(),
  //     binding: SplashBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.LOGIN,
  //     page: () => const LoginPage(),
  //     binding: LoginBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.ROOT,
  //     page: () => const RootPage(),
  //     binding: RootBinding(),
  //     children: [
  //       GetPage(
  //         name: _Paths.WRITE,
  //         page: () => const WritePage(),
  //         binding: WriteBinding(),
  //         fullscreenDialog: true,
  //       ),
  //       GetPage(
  //         name: _Paths.PROFILE,
  //         page: () => const ProfilePage(),
  //         binding: ProfileBinding(),
  //       ),
  //       GetPage(
  //         name: _Paths.ARTICLE,
  //         page: () => const ArticlePage(),
  //         binding: ArticleBinding(),
  //         children: [
  //           GetPage(
  //             name: _Paths.IMAGE,
  //             page: () => const ArticleImagePage(),
  //             binding: ArticleImageBinding(),
  //           ),
  //         ],
  //       ),
  //       GetPage(
  //         name: _Paths.ARTICLE_SECTION,
  //         page: () => const ArticleSectionPage(),
  //         binding: ArticleSectionBinding(),
  //       )
  //     ],
  //   )
  // ];
}
