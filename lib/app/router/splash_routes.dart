part of 'routes.dart';

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData {
  const SplashRoute();
  @override
  Widget build(context, state) => const SplashPage();
}
