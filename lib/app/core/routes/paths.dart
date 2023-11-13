part of 'routes.dart';

abstract class _Paths {
  _Paths._();
  static const splash = '/splash';
  static const login = '/login';
  static const root = '/root';
  static const home = 'home';
  static const search = 'search';
  static const write = 'write';
  static const profile = 'profile';
  static const article = 'article';
  static const articleSection = 'section';
  static const image = 'image';
}

abstract class Paths {
  Paths._();
  static const splash = _Paths.splash;
  static const login = _Paths.login;
  static const root = _Paths.root;
  static const home = '${_Paths.root}/${_Paths.home}';
  static const search = '${_Paths.root}/${_Paths.search}';
  static const write = '${_Paths.root}/${_Paths.write}';
  static const profile = '${_Paths.root}/${_Paths.profile}';
  static const articleDetail = '${_Paths.root}/${_Paths.article}';
  static const articleImage =
      '${_Paths.root}/${_Paths.article}/${_Paths.image}';
  static String articleSection(NoticeType type) =>
      '${_Paths.root}/${_Paths.articleSection}?type=${type.name}';
}
