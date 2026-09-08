import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// One destination of [NativeTabBarHost], described by SF Symbol names.
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

/// Hosts the iOS 26 `UITabBar` platform view shipped with adaptive_platform_ui
/// while handing touches to UIKit as they happen.
///
/// The package's own `IOS26NativeTabBar` registers only a tap recognizer, so
/// Flutter buffers the touch sequence and replays it once the tap has been
/// recognised. iOS 26 tab buttons need a live press: the replayed down/up
/// arrives instantly, the bar highlights the item but never commits the
/// selection, and `tabBar(_:didSelect:)` never fires. An eager recognizer
/// releases the touches to UIKit immediately, which restores tab switching,
/// drag-to-select and the native press feedback.
///
/// Speaks the plugin's `adaptive_platform_ui/ios26_tab_bar` view type and
/// method channel as of adaptive_platform_ui 0.1.111, so keep the dependency
/// pinned or revisit this file when upgrading.
///
/// Never hide or fade this widget: UIKit's `isHidden` makes the Liquid Glass
/// bar paint a black outline for a frame when it returns, and any opacity
/// between 0 and 1 draws the same outline around the view. Move it off screen
/// instead, as [ZiggleNavigationBar] does while the chatbot modal is open.
class NativeTabBarHost extends StatefulWidget {
  const NativeTabBarHost({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onTap,
    required this.tint,
    required this.unselectedItemTint,
  });

  final List<NativeTabDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final Color tint;
  final Color unselectedItemTint;

  @override
  State<NativeTabBarHost> createState() => _NativeTabBarHostState();
}

class _NativeTabBarHostState extends State<NativeTabBarHost> {
  static const _viewType = 'adaptive_platform_ui/ios26_tab_bar';

  /// Height UIKit reports before the platform view has measured itself.
  static const _fallbackHeight = 50.0;

  MethodChannel? _channel;
  double? _intrinsicHeight;
  int? _sentIndex;
  List<String>? _sentLabels;

  int _argb(Color color) => color.toARGB32();

  Map<String, dynamic> _itemParams() => {
    'labels': [for (final d in widget.destinations) d.label],
    'sfSymbols': [for (final d in widget.destinations) d.symbol],
    'selectedSfSymbols': [
      for (final d in widget.destinations) d.selectedSymbol,
    ],
    'searchFlags': [for (final _ in widget.destinations) false],
    'badgeCounts': [for (final _ in widget.destinations) null],
    'spacerFlags': [for (final _ in widget.destinations) false],
    'selectedIndex': widget.selectedIndex,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return SizedBox(
      height: _intrinsicHeight ?? _fallbackHeight,
      child: UiKitView(
        viewType: _viewType,
        creationParams: {
          ..._itemParams(),
          'isDark': isDark,
          'isRtl': isRtl,
          // TabBarMinimizeBehavior.never
          'minimizeBehavior': 0,
          'tint': _argb(widget.tint),
          'unselectedItemTint': _argb(widget.unselectedItemTint),
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<EagerGestureRecognizer>(EagerGestureRecognizer.new),
        },
      ),
    );
  }

  void _onCreated(int id) {
    final channel = MethodChannel('${_viewType}_$id');
    _channel = channel;
    channel.setMethodCallHandler(_onMethodCall);
    _sentIndex = widget.selectedIndex;
    _sentLabels = [for (final d in widget.destinations) d.label];
    _requestIntrinsicSize(channel);
    _sync();
  }

  Future<dynamic> _onMethodCall(MethodCall call) async {
    if (call.method == 'valueChanged') {
      final index = ((call.arguments as Map?)?['index'] as num?)?.toInt();
      if (index != null) {
        _sentIndex = index;
        widget.onTap(index);
      }
    }
    return null;
  }

  Future<void> _requestIntrinsicSize(MethodChannel channel) async {
    try {
      final size = await channel.invokeMethod<Map>('getIntrinsicSize');
      final height = (size?['height'] as num?)?.toDouble();
      if (!mounted || height == null || height <= 0) return;
      setState(() => _intrinsicHeight = height);
    } on PlatformException {
      // Keep the fallback height; UIKit will still lay the bar out.
    }
  }

  @override
  void didUpdateWidget(NativeTabBarHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  Future<void> _sync() async {
    final channel = _channel;
    if (channel == null) return;
    final labels = [for (final d in widget.destinations) d.label];
    if (!listEquals(labels, _sentLabels)) {
      _sentLabels = labels;
      _sentIndex = widget.selectedIndex;
      await channel.invokeMethod('setItems', _itemParams());
    }
    if (_sentIndex != widget.selectedIndex) {
      _sentIndex = widget.selectedIndex;
      await channel.invokeMethod('setSelectedIndex', {
        'index': widget.selectedIndex,
      });
    }
  }

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }
}
