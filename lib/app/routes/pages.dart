import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(name: Routes.HOME, page: () => const SizedBox.shrink()),
  ];
}
