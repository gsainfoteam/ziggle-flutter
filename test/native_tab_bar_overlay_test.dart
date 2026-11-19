import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/native_tab_bar_overlay.dart';

const _channel = MethodChannel('ziggle/native_tab_bar');

Widget _overlay() => Directionality(
  textDirection: TextDirection.ltr,
  child: NativeTabBarOverlay(
    destinations: const [
      NativeTabDestination(
        label: 'Home',
        symbol: 'house',
        selectedSymbol: 'house.fill',
      ),
    ],
    selectedIndex: 0,
    onTap: (_) {},
    onChatbotPressed: () {},
    chatbotLabel: 'Chat',
    tint: const Color(0xFFFF0000),
    unselectedItemTint: const Color(0xFF000000),
    obscured: false,
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  });

  testWidgets('retries the update until the Flutter view has a window', (
    tester,
  ) async {
    var updates = 0;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          if (call.method != 'update') return null;
          updates++;
          if (updates < 3) throw PlatformException(code: 'no_window');
          return 90.0;
        });

    await tester.pumpWidget(_overlay());
    await tester.pump(const Duration(milliseconds: 500));

    expect(updates, 3);
    expect(tester.widget<SizedBox>(find.byType(SizedBox)).height, 90);
  });

  testWidgets('gives up after a bounded number of retries', (tester) async {
    var updates = 0;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          if (call.method != 'update') return null;
          updates++;
          throw PlatformException(code: 'no_window');
        });

    await tester.pumpWidget(_overlay());
    await tester.pump(const Duration(seconds: 5));

    expect(updates, 11);
  });
}
