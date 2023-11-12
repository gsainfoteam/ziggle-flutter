import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:ziggle/app/modules/auth/presentation/pages/login_page.dart';
import 'package:ziggle/app/modules/home/page.dart';

part 'paths.dart';

abstract class Routes {
  Routes._();

  static final _authRoutes = ShellRoute(
    builder: (context, state, child) => BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (context, state) => state.maybeWhen(
        unauthenticated: () => true,
        orElse: () => false,
      ),
      listener: (context, state) => context.go(Paths.login),
      buildWhen: (previous, current) => previous == const AuthState.initial(),
      builder: (context, state) => state.maybeWhen(
        authenticated: (_) => child,
        orElse: () => const SizedBox.shrink(),
      ),
    ),
    routes: [
      GoRoute(
        path: _Paths.root,
        redirect: (context, state) => Paths.home,
        routes: [
          GoRoute(
            path: _Paths.home,
            builder: (_, __) => const HomePage(),
          ),
        ],
      )
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
