import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class PhotoItem extends StatelessWidget {
  const PhotoItem({
    super.key,
    required this.image,
    this.onDelete,
  });

  final ImageProvider image;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Image(
            image: image,
            width: 140,
            height: 140,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: 6,
          top: 6,
          child: GestureDetector(
            onTap: () => print('test'),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFF000000),
                border: Border.all(color: Palette.white, width: 2.5),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Center(
                child: Assets.icons.closeRounded.svg(
                  width: 8,
                  height: 8,
                  colorFilter: const ColorFilter.mode(
                    Palette.white,
                    BlendMode.srcATop,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
