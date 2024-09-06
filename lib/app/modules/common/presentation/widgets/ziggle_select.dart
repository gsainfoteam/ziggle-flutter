import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class ZiggleSelectEntry<T> {
  final T value;
  final String label;

  ZiggleSelectEntry({required this.value, required this.label});
}

class ZiggleSelect<T> extends StatefulWidget {
  const ZiggleSelect({
    super.key,
    this.small = false,
    required this.hintText,
    required this.entries,
    this.onChanged,
  });

  final bool small;
  final String hintText;
  final List<ZiggleSelectEntry<T>> entries;
  final void Function(T?)? onChanged;

  @override
  State<ZiggleSelect> createState() => _ZiggleSelectState();
}

class _ZiggleSelectState<T> extends State<ZiggleSelect<T>> {
  final _overlayController = OverlayPortalController();
  final _link = LayerLink();
  double? _buttonWidth;
  ZiggleSelectEntry<T>? _value;

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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: Scrollbar(
          thumbVisibility: true,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: widget.entries.length + 1,
            itemBuilder: (context, index) {
              final item =
                  index == 0 ? null : widget.entries.elementAt(index - 1);
              return GestureDetector(
                onTap: () {
                  widget.onChanged?.call(item?.value);
                  setState(() => _value = item);
                  _overlayController.hide();
                },
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: widget.small
                      ? const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5) +
                          const EdgeInsets.only(left: 2)
                      : const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12.5) +
                          const EdgeInsets.only(left: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item?.label ?? widget.hintText,
                        style: TextStyle(
                          color: item == null
                              ? Palette.grayText
                              : item == _value
                                  ? Palette.primary
                                  : Palette.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (item != null && item == _value)
                        widget.small
                            ? Assets.icons.check.svg(width: 20, height: 20)
                            : Assets.icons.check.svg(width: 24, height: 24),
                    ],
                  ),
                ),
              );
            },
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
        padding: widget.small
            ? const EdgeInsets.symmetric(vertical: 5, horizontal: 10) +
                const EdgeInsets.only(left: 2)
            : const EdgeInsets.symmetric(vertical: 12, horizontal: 10) +
                const EdgeInsets.only(left: 6),
        decoration: const BoxDecoration(
          color: Palette.grayLight,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _value?.label ?? widget.hintText,
              style: TextStyle(
                color: _value == null ? Palette.grayText : Palette.primary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.small)
              Assets.icons.chevronDown.svg(width: 20, height: 20)
            else
              Assets.icons.chevronDown.svg(width: 24, height: 24),
          ],
        ),
      ),
    );
  }
}
