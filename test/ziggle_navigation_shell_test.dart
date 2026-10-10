import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_navigation_bar.dart';
import 'package:ziggle/app/modules/core/data/repositories/mock_analytics_repository.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';
import 'package:ziggle/app/modules/user/domain/repositories/user_repository.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/gen/strings.g.dart';

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

class _Router extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: ZiggleBottomNavigationRoute.page,
      initial: true,
      children: [
        for (final name in [
          FeedRoute.name,
          CategoryRoute.name,
          ProfileRoute.name,
        ])
          AutoRoute(
            initial: name == FeedRoute.name,
            page: PageInfo(name, builder: (_) => Scaffold(body: Text(name))),
          ),
      ],
    ),
  ];
}

void main() {
  late _UserBloc bloc;
  setUp(() {
    // The chatbot SDK reads the package name while opening.
    PackageInfo.setMockInitialValues(
      appName: 'Ziggle',
      packageName: 'me.gistory.ziggle',
      version: '4.4.0',
      buildNumber: '1',
      buildSignature: '',
    );
    sl.registerSingleton<AnalyticsRepository>(MockAnalyticsRepository());
    // Created and closed outside the widget test's fake-async zone: inside
    // it, Bloc.close never completes and the test hangs.
    bloc = _UserBloc();
  });
  tearDown(() async {
    await bloc.close();
    await sl.reset();
  });

  testWidgets('missing key leaves navigation usable and shows an explanation', (
    tester,
  ) async {
    dotenv.loadFromString(envString: 'CHATBOT_WIDGET_KEY=');
    final router = _Router();
    await tester.pumpWidget(
      TranslationProvider(
        child: BlocProvider<UserBloc>.value(
          value: bloc,
          child: MaterialApp.router(routerConfig: router.config()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open chatbot'));
    await tester.pumpAndSettle();
    expect(
      find.text('Chatbot is currently unavailable. Please try again later.'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<ZiggleNavigationBar>(find.byType(ZiggleNavigationBar))
          .obscured,
      isFalse,
    );
    await tester.tap(find.bySemanticsLabel('Categories'));
    await tester.pumpAndSettle();
    expect(find.text(CategoryRoute.name), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    router.dispose();
  });

  testWidgets('chat overlays the selected route and closes on account change', (
    tester,
  ) async {
    dotenv.loadFromString(
      envString: 'CHATBOT_WIDGET_KEY=widget-test-not-for-network',
    );
    bloc.changeUser(
      UserEntity(
        uuid: 'preview-user',
        name: 'Preview',
        email: 'preview@example.invalid',
        studentId: null,
        consent: DateTime(2026),
      ),
    );
    final router = _Router();
    await tester.pumpWidget(
      TranslationProvider(
        child: BlocProvider<UserBloc>.value(
          value: bloc,
          child: MaterialApp.router(routerConfig: router.config()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Categories'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open chatbot'));
    await tester.pumpAndSettle();
    expect(find.text('무엇을 도와드릴까요?', findRichText: true), findsOneWidget);
    expect(
      tester
          .widget<ZiggleNavigationBar>(find.byType(ZiggleNavigationBar))
          .selectedIndex,
      1,
    );
    bloc.changeUser(null);
    await tester.pump();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();
    expect(find.text('무엇을 도와드릴까요?', findRichText: true), findsNothing);
    final bar = tester.widget<ZiggleNavigationBar>(
      find.byType(ZiggleNavigationBar),
    );
    expect(bar.selectedIndex, 1);
    expect(bar.obscured, isFalse);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 250));
    router.dispose();
  });
}
