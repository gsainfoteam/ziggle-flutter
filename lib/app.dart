import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/app.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/data/services/analytics/service.dart';
import 'package:ziggle/binding.dart';
import 'package:ziggle/gen/strings.g.dart';

import 'app/routes/pages.dart';

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
        child: GetMaterialApp(
          locale: TranslationProvider.of(context).flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.INITIAL,
          initialBinding: initialBinding,
          getPages: AppPages.routes,
          theme: appTheme,
          navigatorObservers: [AnalyticsService.observer],
        ),
      ),
    );
  }
}
