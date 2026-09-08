import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_navigation_bar.dart';
import 'package:ziggle/gen/strings.g.dart';

void main() {
  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    testWidgets('$platform: chat floats apart from the classic bar', (
      tester,
    ) async {
      var selected = 0;
      var chatOpens = 0;
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            theme: ThemeData(platform: platform),
            home: StatefulBuilder(
              builder: (context, setState) => Scaffold(
                floatingActionButton: ZiggleChatbotButton(
                  onPressed: () => chatOpens++,
                ),
                bottomNavigationBar: ZiggleNavigationBar(
                  selectedIndex: selected,
                  onDestinationSelected: (index) =>
                      setState(() => selected = index),
                  onChatbotPressed: () => chatOpens++,
                ),
              ),
            ),
          ),
        ),
      );
      for (final label in ['Home', 'Categories', 'Profile']) {
        expect(find.bySemanticsLabel(label), findsOneWidget);
      }
      await tester.tap(find.bySemanticsLabel('Categories'));
      await tester.pumpAndSettle();
      expect(selected, 1);
      await tester.tap(find.byTooltip('Open chatbot'));
      await tester.pumpAndSettle();
      expect(chatOpens, 1);
      expect(selected, 1);
      await tester.tap(find.bySemanticsLabel('Profile'));
      await tester.pumpAndSettle();
      expect(selected, 2);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('compact layout keeps the bar and button above the inset', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Future<void> pump(bool obscured) => tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 640),
              padding: EdgeInsets.only(bottom: 34),
              viewPadding: EdgeInsets.only(bottom: 34),
              textScaler: TextScaler.linear(1.3),
            ),
            child: Scaffold(
              floatingActionButton: ZiggleChatbotButton(onPressed: () {}),
              bottomNavigationBar: ZiggleNavigationBar(
                selectedIndex: 2,
                onDestinationSelected: (_) {},
                onChatbotPressed: () {},
                obscured: obscured,
              ),
            ),
          ),
        ),
      ),
    );
    await pump(false);
    final barRect = tester.getRect(find.byType(ZiggleNavigationBar));
    expect(barRect.bottom, 640);
    expect(
      tester.getRect(find.bySemanticsLabel('Profile')).bottom,
      lessThanOrEqualTo(606),
    );
    final chatRect = tester.getRect(find.byTooltip('Open chatbot'));
    expect(chatRect.bottom, lessThanOrEqualTo(barRect.top));
    expect(tester.takeException(), isNull);
    // Covering the shell changes nothing on the Flutter-rendered bars.
    await pump(true);
    expect(tester.getRect(find.byType(ZiggleNavigationBar)), barRect);
    expect(find.byTooltip('Open chatbot'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
