import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:upgrader/upgrader.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:ziggle/app/modules/core/presentation/bloc/link_bloc.dart';
import 'package:ziggle/app/modules/core/presentation/bloc/push_message_bloc.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/app/values/strings.dart';
import 'package:ziggle/app/values/theme.dart';
import 'package:ziggle/gen/strings.g.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final smartlook = Smartlook.instance;

  @override
  void initState() {
    super.initState();
    smartlook.start();
    smartlook.preferences.setProjectKey(Strings.smartlookKey);
  }

  @override
  Widget build(BuildContext context) {
    return SmartlookRecordingWidget(
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Palette.white,
        ),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MaterialApp.router(
            theme: AppTheme.theme,
            routerConfig: AppRoutes.config,
            locale: TranslationProvider.of(context).flutterLocale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            builder: (context, child) => _Providers(
              child: UpgradeAlert(
                upgrader: Upgrader(dialogStyle: UpgradeDialogStyle.cupertino),
                navigatorKey: AppRoutes.config.configuration.navigatorKey,
                child: child,
              ),
            ),
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
        BlocProvider(
          lazy: false,
          create: (_) => sl<AuthBloc>()..add(const AuthEvent.load()),
        ),
        BlocProvider(
          create: (_) =>
              sl<PushMessageBloc>()..add(const PushMessageEvent.init()),
        ),
        BlocProvider(
          create: (_) => sl<LinkBloc>()..add(const LinkEvent.init()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<PushMessageBloc, PushMessageState>(
            listener: (context, state) => state.mapOrNull(
              loaded: (s) => context
                  .read<AuthBloc>()
                  .add(AuthEvent.updatePushToken(s.token)),
            ),
          ),
          BlocListener<LinkBloc, LinkState>(
            listener: (context, state) => state.mapOrNull(
              loaded: (s) => WidgetsBinding.instance.addPostFrameCallback((_) {
                AppRoutes.config.push(s.link);
              }),
            ),
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) => state.mapOrNull(
              error: (value) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(value.message)),
              ),
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}
