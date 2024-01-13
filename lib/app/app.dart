import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:upgrader/upgrader.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
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
    smartlook.preferences
        .setProjectKey('559177df225fb6be8f57ab026bcd071f18c172cc');
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
            builder: (context, child) => UpgradeAlert(
              upgrader: Upgrader(
                dialogStyle: UpgradeDialogStyle.cupertino,
                showIgnore: false,
                showLater: false,
              ),
              navigatorKey: AppRoutes.config.configuration.navigatorKey,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
