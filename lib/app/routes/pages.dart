import 'package:get/get.dart';
import 'package:ziggle/app/modules/article/binding.dart';
import 'package:ziggle/app/modules/article/page.dart';
import 'package:ziggle/app/modules/article_image/binding.dart';
import 'package:ziggle/app/modules/article_image/page.dart';
import 'package:ziggle/app/modules/article_section/binding.dart';
import 'package:ziggle/app/modules/article_section/page.dart';
import 'package:ziggle/app/modules/root/binding.dart';
import 'package:ziggle/app/modules/root/page.dart';
import 'package:ziggle/app/modules/login/binding.dart';
import 'package:ziggle/app/modules/login/page.dart';
import 'package:ziggle/app/modules/profile/binding.dart';
import 'package:ziggle/app/modules/profile/page.dart';
import 'package:ziggle/app/modules/splash/binding.dart';
import 'package:ziggle/app/modules/splash/page.dart';
import 'package:ziggle/app/modules/write/binding.dart';
import 'package:ziggle/app/modules/write/page.dart';

part 'routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ROOT,
      page: () => const RootPage(),
      binding: RootBinding(),
      children: [
        GetPage(
          name: _Paths.WRITE,
          page: () => const WritePage(),
          binding: WriteBinding(),
          fullscreenDialog: true,
        ),
        GetPage(
          name: _Paths.PROFILE,
          page: () => const ProfilePage(),
          binding: ProfileBinding(),
        ),
        GetPage(
          name: _Paths.ARTICLE,
          page: () => const ArticlePage(),
          binding: ArticleBinding(),
          children: [
            GetPage(
              name: _Paths.IMAGE,
              page: () => const ArticleImagePage(),
              binding: ArticleImageBinding(),
            ),
          ],
        ),
        GetPage(
          name: _Paths.ARTICLE_SECTION,
          page: () => const ArticleSectionPage(),
          binding: ArticleSectionBinding(),
        )
      ],
    )
  ];
}
