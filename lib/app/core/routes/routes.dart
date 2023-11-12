import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:ziggle/app/modules/auth/presentation/pages/login_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/root_page.dart';
import 'package:ziggle/gen/strings.g.dart';

part 'paths.dart';

abstract class Routes {
  Routes._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final _authRoutes = ShellRoute(
    navigatorKey: _rootNavigatorKey,
    builder: (context, state, child) => BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (context, state) => state.maybeWhen(
        unauthenticated: () => true,
        orElse: () => false,
      ),
      listener: (context, state) => context.go(Paths.login),
      buildWhen: (previous, current) => previous == const AuthState.initial(),
      builder: (context, state) => state.maybeWhen(
        anonymous: () => child,
        authenticated: (_) => child,
        orElse: () => const SizedBox.shrink(),
      ),
    ),
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Paths.profile,
        builder: (context, state) => Scaffold(
            appBar: AppBar(),
            body: Center(
                child: ElevatedButton(
                    onPressed: () => context.push(Paths.home),
                    child: const Text('profile')))),
      ),
      StatefulShellRoute(
        builder: (context, state, navigationShell) => navigationShell,
        navigatorContainerBuilder: (context, navigationShell, children) =>
            RootPage(
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: t.root.main,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label: t.root.search,
            ),
          ],
          shell: navigationShell,
          children: children,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Paths.home,
                builder: (context, state) => Scaffold(
                    appBar: AppBar(),
                    body: Center(
                        child: ElevatedButton(
                            onPressed: () => context.push(Paths.profile),
                            child: const Text('home')))),
              )
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Paths.search,
                builder: (context, state) =>
                    const Center(child: Text('search')),
              )
            ],
          ),
        ],
      ),
    ],
  );
  static final _unauthRoutes = ShellRoute(
    builder: (context, state, child) => BlocListener<AuthBloc, AuthState>(
      listenWhen: (context, state) => state.maybeWhen(
        anonymous: () => true,
        authenticated: (_) => true,
        orElse: () => false,
      ),
      listener: (context, state) => context.go(Paths.home),
      child: child,
    ),
    routes: [
      GoRoute(
        path: _Paths.login,
        builder: (_, __) => const LoginPage(),
      ),
    ],
  );

  static final config = GoRouter(
    initialLocation: Paths.home,
    debugLogDiagnostics: kDebugMode,
    routes: [
      ShellRoute(
        builder: (context, state, child) => _Observer(
          sl(),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (_) => sl<AuthBloc>()..add(const AuthEvent.load())),
            ],
            child: BlocListener<AuthBloc, AuthState>(
              listenWhen: (context, state) => state.maybeWhen(
                orElse: () => true,
                loading: () => false,
                initial: () => false,
              ),
              listener: (context, state) {
                Future.delayed(
                  const Duration(milliseconds: 500),
                  FlutterNativeSplash.remove,
                );
              },
              child: child,
            ),
          ),
        ),
        routes: [_authRoutes, _unauthRoutes],
      ),
    ],
  );

  // static final routes = [
  //   GetPage(
  //     name: _Paths.SPLASH,
  //     page: () => const SplashPage(),
  //     binding: SplashBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.LOGIN,
  //     page: () => const LoginPage(),
  //     binding: LoginBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.ROOT,
  //     page: () => const RootPage(),
  //     binding: RootBinding(),
  //     children: [
  //       GetPage(
  //         name: _Paths.WRITE,
  //         page: () => const WritePage(),
  //         binding: WriteBinding(),
  //         fullscreenDialog: true,
  //       ),
  //       GetPage(
  //         name: _Paths.PROFILE,
  //         page: () => const ProfilePage(),
  //         binding: ProfileBinding(),
  //       ),
  //       GetPage(
  //         name: _Paths.ARTICLE,
  //         page: () => const ArticlePage(),
  //         binding: ArticleBinding(),
  //         children: [
  //           GetPage(
  //             name: _Paths.IMAGE,
  //             page: () => const ArticleImagePage(),
  //             binding: ArticleImageBinding(),
  //           ),
  //         ],
  //       ),
  //       GetPage(
  //         name: _Paths.ARTICLE_SECTION,
  //         page: () => const ArticleSectionPage(),
  //         binding: ArticleSectionBinding(),
  //       )
  //     ],
  //   )
  // ];
}

class _Observer extends StatefulWidget {
  const _Observer(this._repository, {required this.child});

  final Widget child;
  final AnalyticsRepository _repository;

  @override
  State<_Observer> createState() => _ObserverState();
}

class _ObserverState extends State<_Observer> {
  @override
  void initState() {
    super.initState();
    GoRouter.of(context).routerDelegate.addListener(_listener);
  }

  @override
  void dispose() {
    GoRouter.of(context).routerDelegate.removeListener(_listener);
    super.dispose();
  }

  _listener() {
    GoRouter.of(context).routeInformationProvider.value.uri;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final matchList = await GoRouter.of(context)
          .routeInformationParser
          .parseRouteInformationWithDependencies(
            GoRouter.of(context).routeInformationProvider.value,
            context,
          );
      widget._repository.logScreen(matchList.matches.last.matchedLocation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
