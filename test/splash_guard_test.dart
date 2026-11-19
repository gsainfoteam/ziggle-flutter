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

/// How many times the search page was created.
var _searchOpened = 0;

class _SearchPage extends StatefulWidget {
  const _SearchPage();

  @override
  State<_SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<_SearchPage> {
  @override
  void initState() {
    super.initState();
    _searchOpened++;
  }

  @override
  Widget build(BuildContext context) => Scaffold(body: Text(SearchRoute.name));
}

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
    AutoRoute(
      path: '/search',
      page: PageInfo(SearchRoute.name, builder: (_) => const _SearchPage()),
    ),
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
    _searchOpened = 0;
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
        // The same listener as in app.dart.
        child: BlocListener<LinkBloc, LinkState>(
          listener: (context, state) => state.mapOrNull(
            loaded: (s) => WidgetsBinding.instance.addPostFrameCallback((_) {
              router.openLink(s.link);
            }),
          ),
          child: MaterialApp.router(
            routerConfig: router.config(
              reevaluateListenable: ReevaluateListenable.stream(
                MergeStream([auth.stream, user.stream]),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    return router;
  }

  /// The link bloc lives outside the fake-async zone, so deliver real events.
  Future<void> sendLink(WidgetTester tester, String path) async {
    await tester.runAsync(() async {
      links.links.add(path);
      await pumpEventQueue();
    });
    await tester.pump();
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
    await sendLink(tester, '/');
    await tester.pump(AppRouter.splashMinimum);
    await tester.pumpAndSettle();
    expect(stack(router), [ZiggleBottomNavigationRoute.name]);

    // The same while the app is running.
    await sendLink(tester, '/');
    await tester.pumpAndSettle();
    expect(stack(router), [ZiggleBottomNavigationRoute.name]);
  });

  testWidgets('a link that arrives during the splash opens once over home', (
    tester,
  ) async {
    auth.set(const AuthState.authenticated());
    user.changeUser(_consentedUser);
    final router = await launch(tester);
    await sendLink(tester, '/search');
    await tester.pumpAndSettle();
    expect(stack(router), [SplashRoute.name]);

    await tester.pump(AppRouter.splashMinimum);
    await tester.pumpAndSettle();
    expect(stack(router), [ZiggleBottomNavigationRoute.name, SearchRoute.name]);
    expect(_searchOpened, 1);
  });

  testWidgets('a link while the app is running opens once', (tester) async {
    auth.set(const AuthState.authenticated());
    user.changeUser(_consentedUser);
    final router = await launch(tester);
    await tester.pump(AppRouter.splashMinimum);
    await tester.pumpAndSettle();

    await sendLink(tester, '/search');
    await tester.pumpAndSettle();
    expect(stack(router), [ZiggleBottomNavigationRoute.name, SearchRoute.name]);
    expect(_searchOpened, 1);
  });

  testWidgets('a signed-out user is not sent to a link from the splash', (
    tester,
  ) async {
    final router = await launch(tester);
    await sendLink(tester, '/search');
    await tester.pump(AppRouter.splashMinimum);
    auth.set(const AuthState.unauthenticated());
    user.changeUser(null);
    await tester.pumpAndSettle();

    expect(stack(router), [LoginRoute.name]);
    expect(_searchOpened, 0);
  });
}
