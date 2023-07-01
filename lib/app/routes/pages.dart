import 'package:get/get.dart';
import 'package:ziggle/app/modules/home/binding.dart';
import 'package:ziggle/app/modules/home/root_page.dart';
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
  static const INITIAL = Routes.ROOT;

  static final routes = [
    GetPage(
      name: _Paths.ROOT,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const RootPage(),
      binding: HomeBinding(),
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
