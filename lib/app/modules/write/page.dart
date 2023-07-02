import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/modules/write/controller.dart';
import 'package:ziggle/app/modules/write/gallery_item_button.dart';

class WritePage extends GetView<WriteController> {
  const WritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => controller.images.isEmpty
              ? ZiggleButton(
                  text: '폰에서 사진 선택하기...',
                  onTap: controller.selectPhotos,
                )
              : SizedBox(
                  height: 144,
                  child: ListView.separated(
                    clipBehavior: Clip.none,
                    itemCount: controller.images.length + 1,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 4),
                    itemBuilder: (_, index) => index < controller.images.length
                        ? GalleryItemButton(
                            file: controller.images[index],
                            onRemove: () => controller.removeImage(index),
                          )
                        : SizedBox(
                            width: 144,
                            child: ZiggleButton(
                              text: '+',
                              onTap: controller.selectPhotos,
                            ),
                          ),
                  ),
                ),
        ),
      ],
    );
  }
}
