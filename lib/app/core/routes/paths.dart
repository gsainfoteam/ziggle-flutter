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
  static const translation = 'translation';
  static const additional = 'additional';
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
  static String articleDetail(int id) =>
      '${_Paths.root}/${_Paths.article}?id=$id';
  static String articleImage(int id, int page) =>
      '${_Paths.root}/${_Paths.article}/${_Paths.image}?id=$id&page=$page';
  static String articleTranslation(int id) =>
      '${_Paths.root}/${_Paths.article}/${_Paths.translation}?id=$id';
  static String articleAdditional(int id) =>
      '${_Paths.root}/${_Paths.article}/${_Paths.additional}?id=$id';
  static String articleSection(NoticeType type) =>
      '${_Paths.root}/${_Paths.articleSection}?type=${type.name}';
}
