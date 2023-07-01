// ignore_for_file: constant_identifier_names

part of 'pages.dart';

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const ROOT = '/root';
  static const MY_PAGE = '/my';
  static const ARTICLE = '/article';
  static const IMAGE = '/image';
}

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const ROOT = _Paths.ROOT;
  static const MY_PAGE = _Paths.ROOT + _Paths.MY_PAGE;
  static const ARTICLE = _Paths.ROOT + _Paths.ARTICLE;
  static const ARTICLE_IMAGE = _Paths.ROOT + _Paths.ARTICLE + _Paths.IMAGE;
}
