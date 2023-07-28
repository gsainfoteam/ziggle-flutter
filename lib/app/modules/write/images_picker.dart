import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/modules/write/gallery_item_button.dart';
import 'package:ziggle/gen/strings.g.dart';

class ImagesPicker extends StatelessWidget {
  final List<XFile> images;
  final void Function() onAddImage;
  final void Function(int) onRemoveImage;
  const ImagesPicker({
    super.key,
    required this.images,
    required this.onAddImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ZiggleButton(
        text: t.write.images.action,
        onTap: onAddImage,
      ).paddingSymmetric(horizontal: 20);
    }
    return SizedBox(
      height: 144,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        clipBehavior: Clip.none,
        itemCount: images.length + 1,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 4),
        itemBuilder: _galleryItemBuilder,
      ),
    );
  }

  Widget _galleryItemBuilder(BuildContext context, int index) {
    if (index < images.length) {
      return GalleryItemButton(
        file: images[index],
        onRemove: () => onRemoveImage(index),
      );
    }
    return SizedBox(
      width: 144,
      child: ZiggleButton(text: '+', onTap: onAddImage),
    );
  }
}
