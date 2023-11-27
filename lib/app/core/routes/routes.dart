import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/common/presentaion/bloc/messages/messages_bloc.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:ziggle/app/modules/auth/presentation/pages/login_page.dart';
import 'package:ziggle/app/modules/auth/presentation/pages/profile_page.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_summary_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/home_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/notice_additional_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/notice_image_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/notice_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/notice_section_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/notice_translation_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/notice_write_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/root_page.dart';
import 'package:ziggle/app/modules/notices/presentation/pages/search_page.dart';
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
        path: _Paths.root,
        builder: (context, state) => const SizedBox.shrink(),
        routes: [
          GoRoute(
            path: _Paths.article,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => NoticePage(
              notice: state.extra != null
                  ? state.extra as NoticeSummaryEntity
                  : NoticeSummaryEntity(
                      id: int.tryParse(state.uri.queryParameters['id'] ?? '') ??
                          0,
                      createdAt: DateTime.now(),
                    ),
            ),
            routes: [
              GoRoute(
                path: _Paths.image,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => NoticeImagePage(
                  page: int.tryParse(state.uri.queryParameters['page'] ?? '') ??
                      1,
                  images: state.extra as List<String>,
                ),
              ),
              GoRoute(
                path: _Paths.translation,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => NoticeTranslationPage(
                  notice: state.extra as NoticeEntity,
                ),
              ),
              GoRoute(
                path: _Paths.additional,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => NoticeAdditionalPage(
                  notice: state.extra as NoticeEntity,
                ),
              ),
            ],
          ),
          GoRoute(
            path: _Paths.articleSection,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => NoticeSectionPage(
              type: NoticeType.values
                  .byName(state.uri.queryParameters['type'] ?? ''),
            ),
          ),
          GoRoute(
            path: _Paths.write,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: NoticeWritePage(),
            ),
          ),
          GoRoute(
            path: _Paths.profile,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
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
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Paths.search,
                builder: (context, state) => const SearchPage(),
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
              BlocProvider(
                create: (_) =>
                    sl<MessagesBloc>()..add(const MessagesEvent.init()),
              ),
            ],
            child: MultiBlocListener(
              listeners: [
                BlocListener<AuthBloc, AuthState>(
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
                ),
                BlocListener<MessagesBloc, MessagesState>(
                  listener: (context, state) => state.whenOrNull(
                    link: (link) async {
                      final authBloc = context.read<AuthBloc>();
                      if (!authBloc.state.isLoggined) {
                        authBloc.add(const AuthEvent.loginAnonymous());
                        await authBloc.stream.firstWhere((s) => s.isLoggined);
                      }
                      if (!context.mounted) return;
                      context.push(link);
                      return;
                    },
                  ),
                ),
              ],
              child: child,
            ),
          ),
        ),
        routes: [_authRoutes, _unauthRoutes],
      ),
    ],
  );
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
      final parser = GoRouter.of(context).routeInformationParser;
      final provider = GoRouter.of(context).routeInformationProvider;
      final matchList = await parser.parseRouteInformationWithDependencies(
          provider.value, context);
      widget._repository.logScreen(matchList.matches.last.matchedLocation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
