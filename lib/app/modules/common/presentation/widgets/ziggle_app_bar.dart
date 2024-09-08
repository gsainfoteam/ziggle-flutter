import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_back_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_logo.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class ZiggleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ZiggleAppBar({
    super.key,
    this.large = false,
    this.actions = const [],
    this.leading,
    this.title,
    this.backgroundColor,
  });

  final bool large;
  final List<Widget> actions;
  final Widget? leading;
  final Widget? title;
  final Color? backgroundColor;

  factory ZiggleAppBar.main({
    required VoidCallback onTapSearch,
    required VoidCallback onTapWrite,
    Color? backgroundColor,
  }) =>
      ZiggleAppBar(
        backgroundColor: backgroundColor,
        large: true,
        actions: [
          GestureDetector(
            onTap: onTapSearch,
            behavior: HitTestBehavior.translucent,
            child: AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: Assets.icons.search.svg(),
              ),
            ),
          ),
          GestureDetector(
            onTap: onTapWrite,
            behavior: HitTestBehavior.translucent,
            child: AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: Assets.icons.write.svg(),
              ),
            ),
          ),
        ],
      );

  factory ZiggleAppBar.compact({
    required String backLabel,
    required Widget title,
    List<Widget> actions = const [],
    Color? backgroundColor,
  }) =>
      ZiggleAppBar(
        backgroundColor: backgroundColor,
        leading: ZiggleBackButton(
          label: backLabel,
        ),
        title: title,
        actions: actions,
      );

  @override
  Widget build(BuildContext context) {
    if (large) {
      return Container(
        color: backgroundColor,
        child: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
              const ZiggleLogo(),
              const Spacer(),
              ...actions,
            ],
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: const Border(
          bottom: BorderSide(color: Palette.grayBorder),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            if (leading != null)
              Align(
                alignment: Alignment.centerLeft,
                child: leading!,
              ),
            if (title != null)
              Center(
                child: DefaultTextStyle.merge(
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1D1F),
                  ),
                  child: title!,
                ),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(mainAxisSize: MainAxisSize.min, children: actions),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      large ? const Size.fromHeight(50) : const Size.fromHeight(44);
}
