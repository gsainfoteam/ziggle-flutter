part of 'routes.dart';

@TypedGoRoute<MyPageRoute>(path: '/mypage')
class MyPageRoute extends GoRouteData {
  const MyPageRoute();
  @override
  Widget build(context, state) => const AuthRequiredPage(child: ProfilePage());
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData {
  const LoginRoute();
  @override
  Widget build(context, state) => BlocListener<AuthBloc, AuthState>(
        listenWhen: (_, c) => c.hasUser,
        listener: (context, state) => const FeedRoute().go(context),
        child: const LoginPage(),
      );
}
