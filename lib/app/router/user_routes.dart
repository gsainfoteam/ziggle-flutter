part of 'routes.dart';

@TypedGoRoute<SettingRoute>(path: '/setting')
class SettingRoute extends GoRouteData {
  const SettingRoute();
  @override
  Widget build(context, state) => const SettingPage();
}

@TypedGoRoute<InformationRoute>(path: '/setting/information')
class InformationRoute extends GoRouteData {
  const InformationRoute();
  @override
  Widget build(context, state) => const InformationPage();
}
