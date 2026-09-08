import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gist_chatbot_flutter/gist_chatbot_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  test('retained package_info API resolves the app identifier', () async {
    PackageInfo.setMockInitialValues(
      appName: 'Ziggle',
      packageName: 'me.gistory.ziggle',
      version: '4.4.0',
      buildNumber: '1',
      buildSignature: '',
    );
    expect((await PackageInfo.fromPlatform()).packageName, 'me.gistory.ziggle');
  });

  testWidgets(
    'SDK panel opens once, closes and reopens above the current page',
    (tester) async {
      final chatbot = GistChatbot(
        config: const GistChatbotConfig(
          widgetKey: 'widget-test-not-for-network',
        ),
      );
      late BuildContext hostContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              hostContext = context;
              return const Scaffold(body: Text('Current tab'));
            },
          ),
        ),
      );
      final firstOpen = chatbot.open(hostContext);
      await tester.pumpAndSettle();
      expect(chatbot.isOpen, isTrue);
      expect(find.text('무엇을 도와드릴까요?', findRichText: true), findsOneWidget);
      await chatbot.open(hostContext);
      expect(find.text('무엇을 도와드릴까요?', findRichText: true), findsOneWidget);
      chatbot.close();
      await tester.pumpAndSettle();
      await firstOpen;
      expect(chatbot.isOpen, isFalse);
      expect(find.text('Current tab'), findsOneWidget);
      final secondOpen = chatbot.open(hostContext);
      await tester.pumpAndSettle();
      expect(chatbot.isOpen, isTrue);
      Navigator.of(hostContext).pop();
      await tester.pumpAndSettle();
      await secondOpen;
      chatbot.dispose();
      expect(tester.takeException(), isNull);
    },
  );
}
