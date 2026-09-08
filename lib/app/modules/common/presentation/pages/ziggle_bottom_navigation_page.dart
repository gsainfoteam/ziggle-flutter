import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gist_chatbot_flutter/gist_chatbot_flutter.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_navigation_bar.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/app/values/strings.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class ZiggleBottomNavigationPage extends StatefulWidget {
  const ZiggleBottomNavigationPage({super.key});

  @override
  State<ZiggleBottomNavigationPage> createState() =>
      _ZiggleBottomNavigationPageState();
}

class _ZiggleBottomNavigationPageState extends State<ZiggleBottomNavigationPage>
    with AutoRouteAwareStateMixin<ZiggleBottomNavigationPage> {
  // GistChatbot 0.1.1 pops before its 180 ms reverse transition completes.
  static const _chatbotDismissDuration = Duration(milliseconds: 200);
  static const _events = [
    AnalyticsEvent.feed(),
    AnalyticsEvent.category(),
    AnalyticsEvent.profile(),
  ];
  AnalyticsEvent _currentEvent = _events.first;
  GistChatbot? _chatbot;
  bool _chatbotOpen = false;

  /// A route is stacked above this shell, so the native bar must leave the
  /// screen: a platform view would otherwise linger under the pushed page.
  bool _covered = false;

  @override
  void didPushNext() => setState(() => _covered = true);

  @override
  void didPopNext() {
    setState(() => _covered = false);
    AnalyticsRepository.pageView(_currentEvent);
  }

  Future<void> _openChatbot() async {
    if (_chatbotOpen) return;
    final key = Strings.chatbotWidgetKey;
    if (key.isEmpty) {
      context.showToast(context.t.navigation.chatbotUnavailable);
      return;
    }
    setState(() => _chatbotOpen = true);
    try {
      _chatbot ??= GistChatbot(
        config: GistChatbotConfig(
          widgetKey: key,
          colors: const GistChatbotColors(
            primary: Palette.primary,
            button: Palette.primary,
            userMessageBg: Palette.primary,
          ),
        ),
      );
      await _chatbot!.open(context);
    } catch (_) {
      if (mounted) context.showToast(context.t.navigation.chatbotUnavailable);
    } finally {
      await Future<void>.delayed(_chatbotDismissDuration);
      if (mounted) setState(() => _chatbotOpen = false);
    }
  }

  void _resetChatbot() {
    // Let the modal finish its reverse transition before disposing its controller.
    final chatbot = _chatbot;
    _chatbot = null;
    if (chatbot == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Logout can dispose this shell while Navigator is updating its stack.
      chatbot.close();
      Future<void>.delayed(_chatbotDismissDuration, () {
        chatbot.dispose();
      });
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  @override
  void dispose() {
    _resetChatbot();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listenWhen: (previous, current) =>
          previous.user?.uuid != current.user?.uuid,
      listener: (_, _) => _resetChatbot(),
      child: AutoTabsRouter.tabBar(
        physics: const NeverScrollableScrollPhysics(),
        routes: const [FeedRoute(), CategoryRoute(), ProfileRoute()],
        builder: (context, child, tabController) {
          _currentEvent = _events[tabController.index];
          return Scaffold(
            // Only the floating native bar wants the body drawn beneath it.
            extendBody: ZiggleNavigationBar.isNative,
            body: child,
            floatingActionButton: ZiggleNavigationBar.isNative
                ? null
                : ZiggleChatbotButton(onPressed: _openChatbot),
            bottomNavigationBar: ZiggleNavigationBar(
              selectedIndex: tabController.index,
              obscured: _chatbotOpen || _covered,
              onDestinationSelected: (index) {
                AnalyticsRepository.click(_events[index]);
                context.tabsRouter.setActiveIndex(index);
              },
              onChatbotPressed: _openChatbot,
            ),
          );
        },
      ),
    );
  }
}
