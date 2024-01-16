part of 'routes.dart';

abstract class _Paths {
  _Paths._();
  static const String feed = '/';
  static const String notice = '/notice';
  static const String splash = '/splash';
}

abstract class Paths {
  Paths._();

  static const String feed = _Paths.feed;
  static String notice(int id) => '${_Paths.notice}/$id';
}
