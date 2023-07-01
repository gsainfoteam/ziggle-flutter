// ignore_for_file: constant_identifier_names

part of 'pages.dart';

abstract class _Paths {
  _Paths._();
  static const ROOT = '/';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const MY_PAGE = '/my';
}

abstract class Routes {
  Routes._();
  static const ROOT = _Paths.ROOT;
  static const LOGIN = _Paths.LOGIN;
  static const HOME = _Paths.HOME;
  static const MY_PAGE = _Paths.HOME + _Paths.MY_PAGE;
}
