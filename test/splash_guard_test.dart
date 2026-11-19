import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:ziggle/app/modules/core/data/repositories/mock_analytics_repository.dart';
import 'package:ziggle/app/modules/core/domain/repositories/link_repository.dart';
import 'package:ziggle/app/modules/core/presentation/bloc/link_bloc.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';
import 'package:ziggle/app/modules/user/domain/repositories/user_repository.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/auth_bloc.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:ziggle/app/router.dart';
import 'package:ziggle/app/router.gr.dart';

class _AuthRepository implements AuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _AuthBloc extends AuthBloc {
  _AuthBloc() : super(_AuthRepository(), MockAnalyticsRepository());
  void set(AuthState state) => emit(state);
}

class _UserRepository implements UserRepository {
  @override
  Stream<UserEntity?> get me => const Stream.empty();
  @override
  Future<UserEntity?> refetchMe() async => null;
  @override
  Future<void> consent() async {}
  @override
  Future<void> withdraw() async {}
}

class _UserBloc extends UserBloc {
  _UserBloc() : super(_UserRepository(), MockAnalyticsRepository());
  void changeUser(UserEntity? user) => emit(UserState.done(user));
}

class _LinkRepository implements LinkRepository {
  final links = StreamController<String>.broadcast();
  @override
  Stream<String> getLinkStream() => links.stream;
}

final _consentedUser = UserEntity(
  uuid: 'test-user',
  name: 'Test',
  email: 'test@example.invalid',
  studentId: null,
  consent: DateTime(2026),
);

PageInfo _page(String name) =>
    PageInfo(name, builder: (_) => Scaffold(body: Text(name)));

/// The real guards with text-only pages.
class _Router extends AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/', page: _page(SplashRoute.name)),
    AutoRoute(path: '/login', page: _page(LoginRoute.name)),
    AutoRoute(path: '/consent', page: _page(ConsentRoute.name)),
    AutoRoute(
      path: '/home',
      page: PageInfo(
        ZiggleBottomNavigationRoute.name,
        builder: (_) => const AutoRouter(),
      ),
      children: [AutoRoute(path: 'feed', page: _page(FeedRoute.name))],
    ),
    AutoRoute(path: '/search', page: _page(SearchRoute.name)),
  ];
}

void main() {
  late _AuthBloc auth;
  late _UserBloc user;
  late LinkBloc link;
  late _LinkRepository links;

  setUp(() {
    // Created and closed outside the widget test's fake-async zone: inside
    // it, Bloc.close never completes and the test hangs.
    auth = _AuthBloc();
    user = _UserBloc();
    links = _LinkRepository();
    link = LinkBloc(links)..add(const LinkEvent.init());
    sl.registerSingleton<AuthBloc>(auth);
    sl.registerSingleton<UserBloc>(user);
  });
  tearDown(() async {
    await Future.wait([
      auth.close(),
      user.close(),
      link.close(),
      links.links.close(),
    ]);
    await sl.reset();
  });

  Future<_Router> launch(WidgetTester tester) async {
    final router = _Router();
    await tester.pumpWidget(
      BlocProvider<LinkBloc>.value(
        value: link,
        child: MaterialApp.router(
          routerConfig: router.config(
            reevaluateListenable: ReevaluateListenable.stream(
              MergeStream([auth.stream, user.stream]),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    return router;
  }

  List<String> stack(_Router router) => [
    for (final page in router.stack) page.routeData.name,
  ];

  testWidgets('a profile that arrives after the minimum leaves only home', (
    tester,
  ) async {
    auth.set(const AuthState.authenticated());
    final router = await launch(tester);
    expect(find.text(SplashRoute.name), findsOneWidget);

    // #721: the profile took longer than the splash minimum.
    await tester.pump(const Duration(milliseconds: 1500));
    expect(stack(router), [SplashRoute.name]);
    user.changeUser(_consentedUser);
    await tester.pumpAndSettle();

    expect(stack(router), [ZiggleBottomNavigationRoute.name]);
    expect(find.text(FeedRoute.name), findsOneWidget);
  });

  testWidgets('a quick profile still shows the splash for the minimum', (
    tester,
  ) async {
    auth.set(const AuthState.authenticated());
    final router = await launch(tester);
    user.changeUser(_consentedUser);
    await tester.pump(const Duration(milliseconds: 500));
    expect(stack(router), [SplashRoute.name]);

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    expect(stack(router), [ZiggleBottomNavigationRoute.name]);
  });

  testWidgets('a signed-out user goes from the splash to login', (
    tester,
  ) async {
    final router = await launch(tester);
    await tester.pump(AppRouter.splashMinimum);
    auth.set(const AuthState.unauthenticated());
    user.changeUser(null);
    await tester.pumpAndSettle();

    expect(stack(router), [LoginRoute.name]);
  });

  testWidgets('a root link neither brings the splash back nor loops', (
    tester,
  ) async {
    auth.set(const AuthState.authenticated());
    user.changeUser(_consentedUser);
    final router = await launch(tester);
    // A link without `redirect` becomes `/`, which is the splash.
    links.links.add('/');
    await tester.pump();
    await router.pushPath('/');
    await tester.pump(AppRouter.splashMinimum);
    await tester.pumpAndSettle();
    expect(stack(router), [ZiggleBottomNavigationRoute.name]);

    // The same while the app is running.
    await router.pushPath('/');
    await tester.pumpAndSettle();
    expect(stack(router), [ZiggleBottomNavigationRoute.name]);
  });

  testWidgets('a link opened over the splash does not leave it behind', (
    tester,
  ) async {
    auth.set(const AuthState.authenticated());
    user.changeUser(_consentedUser);
    final router = await launch(tester);
    // app.dart pushes every loaded link at once, here on top of the splash.
    links.links.add('/search');
    await tester.pump();
    // Completes only when the page is popped, so do not wait for it.
    unawaited(router.pushPath('/search'));
    await tester.pumpAndSettle();
    expect(stack(router), [SplashRoute.name, SearchRoute.name]);

    await tester.pump(AppRouter.splashMinimum);
    await tester.pumpAndSettle();
    expect(stack(router), [ZiggleBottomNavigationRoute.name, SearchRoute.name]);
  });
}
