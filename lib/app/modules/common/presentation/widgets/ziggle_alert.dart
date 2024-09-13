import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class ZiggleAlert extends StatelessWidget {
  const ZiggleAlert({
    super.key,
    required this.warnMessage,
  });

  final String warnMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.0,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Palette.primaryLight,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Palette.primary,
          width: 1.0,
        ),
      ),
      child: IntrinsicWidth(
        child: Center(
          child: Row(
            children: [
              Assets.icons.warningTriangle.svg(
                width: 14.0,
                height: 14.0,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                warnMessage,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.normal,
                  color: Palette.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
