// ignore_for_file: constant_identifier_names

part of 'pages.dart';

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const ROOT = '/root';
  static const PROFILE = '/profile';
  static const ARTICLE = '/article';
  static const ARTICLE_SECTION = '/section';
  static const IMAGE = '/image';
}

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const ROOT = _Paths.ROOT;
  static const PROFILE = _Paths.ROOT + _Paths.PROFILE;
  static const ARTICLE = _Paths.ROOT + _Paths.ARTICLE;
  static const ARTICLE_IMAGE = _Paths.ROOT + _Paths.ARTICLE + _Paths.IMAGE;
  static const ARTICLE_SECTION = _Paths.ROOT + _Paths.ARTICLE_SECTION;
}
