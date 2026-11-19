import 'package:flutter/widgets.dart';

/// Exposes the entrance transition of the route that hosts a nested
/// navigator to the pages inside it.
///
/// The initial page of a nested navigator never animates, so
/// `ModalRoute.of(context)` there reports a finished transition even while
/// the outer route is still sliding in. Shell layouts wrap their nested
/// router in this widget; [RouteEntrance.of] falls back to the nearest
/// route when there is none.
class RouteEntrance extends InheritedWidget {
  const RouteEntrance({
    super.key,
    required this.animation,
    required super.child,
  });

  final Animation<double>? animation;

  /// The entrance animation of the page around [context], or null if it has
  /// none. Does not register a dependency on [RouteEntrance].
  static Animation<double>? of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<RouteEntrance>();
    if (scope != null) return scope.animation;
    return ModalRoute.of(context)?.animation;
  }

  @override
  bool updateShouldNotify(RouteEntrance oldWidget) =>
      animation != oldWidget.animation;
}
