import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
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
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const SizedBox.shrink(),
      children: [
        GetPage(
          name: Routes.MY_PAGE,
          page: () => const MyPage(),
          binding: MyBinding(),
        )
      ],
    )
  ];
}
