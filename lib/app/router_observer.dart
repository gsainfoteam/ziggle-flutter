import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';

@injectable
class AppRouterObserver extends AutoRouterObserver {
  final AnalyticsRepository _repository;

  AppRouterObserver(this._repository);

  @override
  void didPush(Route route, Route? previousRoute) {
    final name = route.settings.name;
    if (name != null) {
      _repository.logScreen(name);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    final name = previousRoute?.settings.name;
    if (name != null) {
      _repository.logScreen(name);
    }
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    final name = route.routeInfo.name;
    _repository.logScreen(name);
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    final name = route.routeInfo.name;
    _repository.logScreen(name);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    final name = newRoute?.settings.name;
    if (name != null) {
      _repository.logScreen(name);
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    final name = previousRoute?.settings.name;
    if (name != null) {
      _repository.logScreen(name);
    }
  }
}
