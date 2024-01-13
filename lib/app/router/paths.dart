part of 'routes.dart';

abstract class _Paths {
  _Paths._();
  static const String feed = '/';
  static const String splash = '/splash';
}

abstract class Paths {
  Paths._();

  static const String feed = _Paths.feed;
}
