import 'package:get/get.dart';
import 'package:ziggle/app/modules/root/binding.dart';
import 'package:ziggle/app/modules/root/page.dart';
import 'package:ziggle/app/modules/login/binding.dart';
import 'package:ziggle/app/modules/login/page.dart';
import 'package:ziggle/app/modules/my/binding.dart';
import 'package:ziggle/app/modules/my/page.dart';
import 'package:ziggle/app/modules/splash/binding.dart';
import 'package:ziggle/app/modules/splash/page.dart';

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
          name: _Paths.MY_PAGE,
          page: () => const MyPage(),
          binding: MyBinding(),
        )
      ],
    )
  ];
}
