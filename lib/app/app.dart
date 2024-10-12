import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/core/presentation/bloc/link_bloc.dart';
import 'package:ziggle/app/modules/core/presentation/bloc/messaging_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/cubit/copy_link_cubit.dart';
import 'package:ziggle/app/modules/notices/presentation/cubit/share_cubit.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/auth_bloc.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/developer_option_bloc.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/group_auth_bloc.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:ziggle/app/router.dart';
import 'package:ziggle/app/router_observer.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/app/values/theme.dart';
import 'package:ziggle/gen/strings.g.dart';

final _appRouter = AppRouter();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Palette.white,
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp.router(
          theme: AppTheme.theme,
          routerConfig: _appRouter.config(
            navigatorObservers: () => [
              AutoRouteObserver(),
              sl<AppRouterObserver>(),
            ],
          ),
          locale: TranslationProvider.of(context).flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          builder: (context, child) => _Providers(
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

class _Providers extends StatelessWidget {
  const _Providers({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<GroupAuthBloc>()),
        BlocProvider(
          lazy: false,
          create: (_) => sl<AuthBloc>()..add(const AuthEvent.load()),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => sl<UserBloc>()..add(const UserEvent.init()),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => sl<MessagingBloc>()..add(const MessagingEvent.init()),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => sl<LinkBloc>()..add(const LinkEvent.init()),
        ),
        BlocProvider(create: (_) => sl<ShareCubit>()),
        BlocProvider(create: (_) => sl<CopyLinkCubit>()),
        BlocProvider(
          create: (_) =>
              sl<DeveloperOptionBloc>()..add(const DeveloperOptionEvent.load()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) => state.whenOrNull(
              error: (message) => context.showToast(message),
            ),
          ),
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
                current.mapOrNull(
                  authenticated: (_) => true,
                  unauthenticated: (_) => true,
                ) ??
                false,
            listener: (context, state) => context
                .read<MessagingBloc>()
                .add(const MessagingEvent.refresh()),
          ),
          BlocListener<LinkBloc, LinkState>(
            listener: (context, state) => state.mapOrNull(
              loaded: (s) => WidgetsBinding.instance.addPostFrameCallback((_) {
                _appRouter.pushNamed(s.link);
              }),
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}
