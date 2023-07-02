import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/core/values/shadows.dart';

class GalleryItemButton extends StatelessWidget {
  final XFile file;
  final void Function()? onTap;
  final void Function()? onRemove;
  final bool isMain;

  const GalleryItemButton({
    super.key,
    required this.file,
    this.onTap,
    this.onRemove,
    required this.isMain,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 144,
      height: 144,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: 136,
              height: 136,
              decoration: isMain
                  ? BoxDecoration(
                      border: Border.all(
                        color: Palette.primaryColor,
                        width: 4,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    )
                  : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: GestureDetector(
                  onTap: onTap,
                  child: Image.file(
                    File(file.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: frameShadows,
              ),
              child: GestureDetector(
                onTap: onRemove,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
