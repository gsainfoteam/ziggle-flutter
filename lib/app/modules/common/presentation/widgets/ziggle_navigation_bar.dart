import 'dart:math';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/native_tab_bar_host.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

/// Popo wearing a headset, rasterised from `assets/icons/chatbot.svg` at
/// 33 pt with strokes matching the tab icons' weight. Not a template image:
/// it carries its own black and white. [width] scales it for smaller buttons.
Widget _chatIcon({double? width}) =>
    Assets.icons.chatbotPng.image(width: width);

/// Mascot width that fits a chat button of [buttonSize].
double _chatIconWidth(double buttonSize) => buttonSize * 33 / 60;

/// Bottom navigation for the three destinations.
///
/// On iOS 26 this is the native Liquid Glass pill with the chatbot action as a
/// detached glass circle beside it, like a trailing search tab. Everywhere
/// else it is the app's classic bar and the chatbot lives in
/// [ZiggleChatbotButton], which the page places in the floating action slot.
///
/// Opening chat never selects a tab.
class ZiggleNavigationBar extends StatelessWidget {
  const ZiggleNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onChatbotPressed,
    this.obscured = false,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  /// Only used by the native bar, which owns its chatbot button.
  final VoidCallback onChatbotPressed;

  /// A route covers this bar. The native platform views slide off screen so
  /// they cannot paint through it; the Flutter bars need nothing.
  final bool obscured;

  /// Whether the iOS 26 native bar is in use. It floats over the body and
  /// carries its own chatbot button, so the page extends the body under it
  /// and leaves the floating action slot empty. The classic bar is opaque
  /// and takes [ZiggleChatbotButton] in that slot instead.
  static bool get isNative => PlatformInfo.isIOS26OrHigher();

  // Native bar geometry, measured on iOS 26.5. UITabBar changes its layout
  // with the horizontal size class, so there are two sets of metrics.
  //
  // Compact width (iPhone): items stack icon over label, the pill is 60 pt
  // tall and stops widening at 270 pt, so its edges are predictable and the
  // chat button can sit a fixed gap beside it.
  static const _chatSize = 60.0;
  static const _chatGap = 12.0;
  static const _edgeMargin = 22.0;

  /// UITabBar keeps this inset between its frame and the pill it draws.
  static const _nativeInset = 22.0;

  /// UITabBar stops widening the pill once three items have this much room.
  static const _pillMaxWidth = 270.0;

  // Regular width (iPad): items go inline, icon beside label, so the pill's
  // width follows the label text and cannot be predicted. The bar spans the
  // full width and UIKit centres the pill itself; the 46 pt chat button is
  // pinned to the trailing edge instead of beside the pill.
  static const _regularChatSize = 46.0;

  /// Below this width UIKit treats the window as compact (iPhone, narrow
  /// iPad split view) and stacks the tab items.
  static const _regularWidth = 600.0;

  /// Slide-away time while a route covers the native bar. Callers that open
  /// a modal over the native bar should wait this long after setting
  /// [obscured] before pushing, so no platform view is left under the modal.
  static const hideDuration = Duration(milliseconds: 200);

  static List<String> _labels(BuildContext context) => [
    context.t.navigation.home,
    context.t.navigation.category,
    context.t.navigation.profile,
  ];

  @override
  Widget build(BuildContext context) {
    final labels = _labels(context);
    if (isNative) return _buildNative(context, labels);
    return _buildClassic(labels);
  }

  Widget _buildNative(BuildContext context, List<String> labels) {
    const symbols = ['house', 'square.grid.2x2', 'person.crop.circle'];
    const selectedSymbols = [
      'house.fill',
      'square.grid.2x2.fill',
      'person.crop.circle.fill',
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final regular = width >= _regularWidth;
        final double barLeft;
        final double barRight;
        final double chatLeft;
        final double chatSize;
        if (regular) {
          barLeft = 0;
          barRight = 0;
          chatSize = _regularChatSize;
          chatLeft = width - _edgeMargin - chatSize;
        } else {
          final pillWidth = min(
            _pillMaxWidth,
            width - 2 * _edgeMargin - _chatGap - _chatSize,
          );
          final side = (width - pillWidth - _chatGap - _chatSize) / 2;
          barLeft = side - _nativeInset;
          barRight = width - side - pillWidth - _nativeInset;
          chatSize = _chatSize;
          chatLeft = side + pillWidth + _chatGap;
        }
        // The bar keeps its intrinsic height, which already covers the home
        // indicator; it draws the pill at its top edge, 60 pt tall on compact
        // widths and 46 pt on regular ones, which the chat button matches.
        //
        // While a route covers the shell the whole row slides below the
        // screen. Liquid Glass views cannot be hidden or faded without
        // painting a black outline (see NativeTabBarHost), but moving them
        // off screen is safe and keeps them warm for the return.
        return IgnorePointer(
          ignoring: obscured,
          child: AnimatedSlide(
            offset: obscured ? const Offset(0, 1) : Offset.zero,
            duration: hideDuration,
            curve: Curves.easeInOut,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: barLeft, right: barRight),
                  child: NativeTabBarHost(
                    destinations: [
                      for (var i = 0; i < labels.length; i++)
                        NativeTabDestination(
                          label: labels[i],
                          symbol: symbols[i],
                          selectedSymbol: selectedSymbols[i],
                        ),
                    ],
                    selectedIndex: selectedIndex,
                    onTap: onDestinationSelected,
                    tint: Palette.primary,
                    unselectedItemTint: Palette.black,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: chatLeft,
                  child: SizedBox.square(
                    dimension: chatSize,
                    child: Semantics(
                      label: context.t.navigation.chatbot,
                      button: true,
                      onTap: onChatbotPressed,
                      excludeSemantics: true,
                      child: IOS26Button.child(
                        onPressed: onChatbotPressed,
                        style: IOS26ButtonStyle.glass,
                        color: Palette.black,
                        borderRadius: BorderRadius.circular(chatSize / 2),
                        useSmoothRectangleBorder: false,
                        child: _chatIcon(width: _chatIconWidth(chatSize)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// The app's own bar, unchanged from before the iOS 26 work: white with a
  /// hairline on top and icon-only destinations.
  Widget _buildClassic(List<String> labels) {
    final icons = [
      Assets.icons.feed,
      Assets.icons.category,
      Assets.icons.profile,
    ];
    final selectedIcons = [
      Assets.icons.feedActive,
      Assets.icons.categoryActive,
      Assets.icons.profileActive,
    ];
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Palette.white,
        border: Border(top: BorderSide(color: Palette.grayBorder)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              for (var i = 0; i < labels.length; i++)
                Expanded(
                  child: Semantics(
                    label: labels[i],
                    button: true,
                    selected: i == selectedIndex,
                    child: ZigglePressable(
                      onPressed: () => onDestinationSelected(i),
                      // The whole third of the bar is the target, not just
                      // the 24 pt glyph.
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 24,
                              child:
                                  (i == selectedIndex
                                          ? selectedIcons[i]
                                          : icons[i])
                                      .svg(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Floating chatbot action for platforms without the native iOS 26 bar.
///
/// Meant for `Scaffold.floatingActionButton`, so it sits above the bar at the
/// trailing edge and looks the same on Android and older iOS. Styled like a
/// [ZiggleButton]: flat, hairline border, no shadow, with corners rounded a
/// little more (16 pt) than the app's buttons so it reads as a floating
/// action. The page
/// leaves the slot empty when [ZiggleNavigationBar.isNative], since the
/// native bar carries its own button.
class ZiggleChatbotButton extends StatelessWidget {
  const ZiggleChatbotButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  static const _size = 56.0;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.t.navigation.chatbot,
      child: Semantics(
        button: true,
        child: ZigglePressable(
          onPressed: onPressed,
          decoration: BoxDecoration(
            color: Palette.white,
            border: Border.all(color: Palette.grayBorder),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox.square(
            dimension: _size,
            child: Center(child: _chatIcon()),
          ),
        ),
      ),
    );
  }
}
