import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_auth_2_platform_interface/flutter_web_auth_2_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:ziggle/app/modules/core/data/repositories/mock_analytics_repository.dart';
import 'package:ziggle/app/modules/core/domain/enums/api_channel.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/core/domain/repositories/api_channel_repository.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';
import 'package:ziggle/app/modules/user/domain/repositories/developer_option_repository.dart';
import 'package:ziggle/app/modules/user/domain/repositories/notification_setting_repository.dart';
import 'package:ziggle/app/modules/user/domain/repositories/user_repository.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/auth_bloc.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/developer_option_bloc.dart';
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

class _AuthRepository implements AuthRepository {
  @override
  Stream<bool> get isSignedIn => const Stream.empty();
  @override
  Future<void> login() async {}
  @override
  Future<void> logout() async {}
}

class _DeveloperOptionRepository implements DeveloperOptionRepository {
  @override
  Future<bool> getDeveloperOption() async => false;
  @override
  Future<void> setDeveloperOption(bool value) async {}
}

class _ApiChannelRepository implements ApiChannelRepository {
  @override
  Stream<ApiChannel> get channel => const Stream.empty();
  @override
  void setChannel(ApiChannel channel) {}
  @override
  ApiChannel toggleChannel() => ApiChannel.byMode();
  @override
  String get ziggleBaseUrl => '';
}

class _NotificationSettingRepository implements NotificationSettingRepository {
  @override
  Future<bool> isNotificationEnabled() async => true;
  @override
  Future<bool> enableNotification() async => true;
}

class _WebAuth extends Fake
    with MockPlatformInterfaceMixin
    implements FlutterWebAuth2Platform {
  final calls = <(String, String)>[];

  @override
  Future<String> authenticate({
    required String url,
    required String callbackUrlScheme,
    required Map<String, dynamic> options,
  }) async {
    calls.add((url, callbackUrlScheme));
    // The account site never redirects back; the user closes the sheet.
    throw PlatformException(code: 'CANCELED');
  }

  @override
  Future clearAllDanglingCalls() async {}
}

class _Router extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SettingRoute.page, initial: true),
  ];
}

void main() {
  late _UserBloc userBloc;
  late AuthBloc authBloc;
  late DeveloperOptionBloc developerOptionBloc;
  late _WebAuth webAuth;

  setUp(() {
    sl.registerSingleton<AnalyticsRepository>(MockAnalyticsRepository());
    sl.registerSingleton<NotificationSettingRepository>(
      _NotificationSettingRepository(),
    );
    dotenv.loadFromString(envString: 'IDP_REDIRECT_SCHEME=ziggle');
    webAuth = _WebAuth();
    FlutterWebAuth2Platform.instance = webAuth;
    // Created and closed outside the widget test's fake-async zone: inside
    // it, Bloc.close never completes and the test hangs.
    userBloc = _UserBloc();
    authBloc = AuthBloc(_AuthRepository(), MockAnalyticsRepository());
    developerOptionBloc = DeveloperOptionBloc(
      _DeveloperOptionRepository(),
      _ApiChannelRepository(),
    );
  });
  tearDown(() async {
    await userBloc.close();
    await authBloc.close();
    await developerOptionBloc.close();
    await sl.reset();
  });

  Future<_Router> pumpSettingPage(WidgetTester tester) async {
    final router = _Router();
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<UserBloc>.value(value: userBloc),
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<DeveloperOptionBloc>.value(value: developerOptionBloc),
          ],
          child: MaterialApp.router(
            routerConfig: router.config(
              navigatorObservers: () => [AutoRouteObserver()],
            ),
          ),
        ),
      ),
    );
    // ZiggleButton keeps an invisible loading animation running, so the
    // page never settles; pump past the route transition instead.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    return router;
  }

  testWidgets(
    'signed-in user can open the account site in the web auth sheet',
    (tester) async {
      userBloc.changeUser(
        UserEntity(
          uuid: 'preview-user',
          name: 'Preview',
          email: 'preview@example.invalid',
          studentId: null,
          consent: DateTime(2026),
        ),
      );
      final router = await pumpSettingPage(tester);

      final editInfo = find.text(t.user.account.editInfo);
      expect(editInfo, findsOneWidget);
      // Shown at the top of the account section, above logout and withdraw.
      expect(
        tester.getTopLeft(editInfo).dy,
        lessThan(tester.getTopLeft(find.text(t.user.account.logout)).dy),
      );

      await tester.tap(editInfo);
      await tester.pump(const Duration(milliseconds: 300));
      expect(webAuth.calls, [('https://account.gistory.me/', 'ziggle')]);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox.shrink());
      router.dispose();
    },
  );

  testWidgets('signed-out user does not see the account edit button', (
    tester,
  ) async {
    userBloc.changeUser(null);
    final router = await pumpSettingPage(tester);

    expect(find.text(t.user.account.editInfo), findsNothing);
    expect(find.text(t.user.account.login), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    router.dispose();
  });
}
