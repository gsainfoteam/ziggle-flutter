import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class Tag extends StatefulWidget {
  const Tag({
    super.key,
    this.onDelete = false,
    this.onPressed,
    this.loading = false,
    this.tag = '#태그1',
  });

  final bool onDelete;
  final VoidCallback? onPressed;
  final bool loading;
  final String tag;

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37.0,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: widget.onDelete ? Palette.primaryMedium : Palette.primaryLight,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: IntrinsicWidth(
        child: Center(
          child: Row(
            children: [
              Text(
                widget.tag,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                  color: Palette.primary,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.onDelete)
                const SizedBox(
                  width: 10,
                ),
              if (widget.onDelete)
                GestureDetector(
                  onTapDown: (_) => setState(() => _pressed = true),
                  onTapUp: (_) => setState(() => _pressed = false),
                  onTapCancel: () => setState(() => _pressed = false),
                  onTap: widget.loading ? null : widget.onPressed,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 100),
                    scale: widget.onPressed != null && _pressed ? 0.95 : 1,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      child: Assets.icons.xmarkCircle.svg(
                        width: 24.0 *
                            (widget.onPressed != null && _pressed ? 0.95 : 1),
                        height: 24.0 *
                            (widget.onPressed != null && _pressed ? 0.95 : 1),
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
