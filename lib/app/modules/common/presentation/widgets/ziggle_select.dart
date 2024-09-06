import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class ZiggleSelect extends StatefulWidget {
  const ZiggleSelect({
    super.key,
    required this.small,
  });

  final bool small;

  @override
  State<ZiggleSelect> createState() => _ZiggleSelectState();
}

class _ZiggleSelectState extends State<ZiggleSelect> {
  final _overlayController = OverlayPortalController();
  final _link = LayerLink();
  double? _buttonWidth;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (context) => CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.topLeft,
          child: Align(
            alignment: Alignment.topLeft,
            child: _buildSelector(),
          ),
        ),
        child: _buildPicker(),
      ),
    );
  }

  Widget _buildSelector() {
    return Container(
      width: _buttonWidth,
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(color: Palette.grayBorder, strokeAlign: 1),
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Palette.white,
      ),
      child: SizedBox(
        height: 200,
        child: Scrollbar(
          thumbVisibility: true,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            // shrinkWrap: true,
            itemBuilder: (context, index) => GestureDetector(
              onTap: _overlayController.hide,
              behavior: HitTestBehavior.translucent,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12.5),
                child: Text(
                  'asdf',
                  style: TextStyle(
                    color: Palette.grayText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            itemCount: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildPicker() {
    return GestureDetector(
      onTap: () {
        _buttonWidth = context.size?.width;
        _overlayController.show();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Palette.grayLight,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'asdf',
              style: TextStyle(
                color: Palette.grayText,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Assets.icons.chevronDown.svg(width: 24, height: 24),
          ],
        ),
      ),
    );
  }
}
