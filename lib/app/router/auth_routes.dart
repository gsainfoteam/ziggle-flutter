part of 'routes.dart';

@TypedGoRoute<MyPageRoute>(path: '/mypage')
class MyPageRoute extends GoRouteData {
  const MyPageRoute();
  @override
  Widget build(context, state) => const AuthRequiredPage(child: ProfilePage());
}
