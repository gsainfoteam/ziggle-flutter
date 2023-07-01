// ignore_for_file: constant_identifier_names

part of 'pages.dart';

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const ROOT = '/root';
  static const MY_PAGE = '/my';
}

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const ROOT = _Paths.ROOT;
  static const MY_PAGE = _Paths.ROOT + _Paths.MY_PAGE;
}
