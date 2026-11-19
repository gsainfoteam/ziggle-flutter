import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// One destination of [NativeTabBarOverlay], described by SF Symbol names.
class NativeTabDestination {
  const NativeTabDestination({
    required this.label,
    required this.symbol,
    required this.selectedSymbol,
  });

  final String label;
  final String symbol;
  final String selectedSymbol;
}

/// Shows the iOS 26 Liquid Glass tab bar and chatbot button, drawn by UIKit
/// above the Flutter view (`ios/Runner/NativeTabBarOverlay.swift`).
///
/// They used to be platform views. With a platform view on screen Flutter
/// composites every frame around it and synchronises its presentation with
/// Core Animation, and the feed scrolling underneath the glass looked
/// choppy even though Flutter's frame timings stayed well inside budget. As
/// a window-level overlay the native views cost Flutter nothing.
///
/// This widget only reserves the bar's height at the bottom of the page and
/// sends the bar state to UIKit. Because the native views sit above every
/// Flutter route, [obscured] must be set whenever anything covers the shell
/// (pushed pages, dialogs, sheets); the bar then slides off screen.
///
/// Only one instance may be mounted at a time.
class NativeTabBarOverlay extends StatefulWidget {
  const NativeTabBarOverlay({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onTap,
    required this.onChatbotPressed,
    required this.chatbotLabel,
    required this.tint,
    required this.unselectedItemTint,
    required this.obscured,
  });

  final List<NativeTabDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onChatbotPressed;

  /// Accessibility label of the chatbot button.
  final String chatbotLabel;
  final Color tint;
  final Color unselectedItemTint;

  /// Slides the bar and button below the screen and ignores touches.
  final bool obscured;

  @override
  State<NativeTabBarOverlay> createState() => _NativeTabBarOverlayState();
}

class _NativeTabBarOverlayState extends State<NativeTabBarOverlay> {
  static const _channel = MethodChannel('ziggle/native_tab_bar');

  /// Bar height before UIKit has measured it: the 50 pt bar plus the home
  /// indicator.
  static const _fallbackHeight = 50.0;

  double? _height;
  Map<String, Object?>? _sent;

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler(_onMethodCall);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleSync();
  }

  @override
  void didUpdateWidget(NativeTabBarOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleSync();
  }

  @override
  void dispose() {
    _channel.setMethodCallHandler(null);
    _channel.invokeMethod<void>('dispose');
    super.dispose();
  }

  Map<String, Object?> _config() {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return {
      'labels': [for (final d in widget.destinations) d.label],
      'symbols': [for (final d in widget.destinations) d.symbol],
      'selectedSymbols': [
        for (final d in widget.destinations) d.selectedSymbol,
      ],
      'selectedIndex': widget.selectedIndex,
      'tint': widget.tint.toARGB32(),
      'unselectedTint': widget.unselectedItemTint.toARGB32(),
      'isDark': isDark,
      'isRtl': Directionality.of(context) == TextDirection.rtl,
      'obscured': widget.obscured,
      'chatbotLabel': widget.chatbotLabel,
    };
  }

  /// Sends the state after this frame, once the Flutter view is in its
  /// window. Skips calls that would not change anything.
  void _scheduleSync() {
    final config = _config();
    if (_sameConfig(config, _sent)) return;
    _sent = config;
    WidgetsBinding.instance.addPostFrameCallback((_) => _send(config));
  }

  /// How often to retry while the Flutter view is not in a window yet.
  /// Nothing else would trigger another update if the config stays the
  /// same, and the bar would never appear.
  static const _windowRetries = 10;
  static const _windowRetryDelay = Duration(milliseconds: 100);

  Future<void> _send(Map<String, Object?> config, [int attempt = 0]) async {
    if (!mounted || !identical(_sent, config)) return;
    try {
      final height = await _channel.invokeMethod<double>('update', config);
      if (mounted && height != null && height > 0) _setHeight(height);
    } on PlatformException catch (e) {
      if (e.code == 'no_window' && attempt < _windowRetries) {
        await Future<void>.delayed(_windowRetryDelay);
        return _send(config, attempt + 1);
      }
      debugPrint('Native tab bar update failed: $e');
      // Retry with the next change.
      if (identical(_sent, config)) _sent = null;
    }
  }

  static bool _sameConfig(Map<String, Object?> a, Map<String, Object?>? b) {
    if (b == null || a.length != b.length) return false;
    for (final entry in a.entries) {
      final other = b[entry.key];
      final value = entry.value;
      if (value is List && other is List) {
        if (!listEquals(value, other)) return false;
      } else if (value != other) {
        return false;
      }
    }
    return true;
  }

  void _setHeight(double height) {
    if (height == _height) return;
    setState(() => _height = height);
  }

  Future<void> _onMethodCall(MethodCall call) async {
    final args = call.arguments as Map?;
    switch (call.method) {
      case 'valueChanged':
        final index = (args?['index'] as num?)?.toInt();
        if (index != null) widget.onTap(index);
      case 'chatbotPressed':
        widget.onChatbotPressed();
      case 'heightChanged':
        final height = (args?['height'] as num?)?.toDouble();
        if (mounted && height != null && height > 0) _setHeight(height);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Transparent: the native bar is drawn above this space by UIKit.
    return SizedBox(
      height:
          _height ?? _fallbackHeight + MediaQuery.viewPaddingOf(context).bottom,
    );
  }
}
