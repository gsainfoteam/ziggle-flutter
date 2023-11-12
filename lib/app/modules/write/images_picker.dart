import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ziggle/app/common/presentaion/widgets/button.dart';
import 'package:ziggle/app/data/services/analytics/service.dart';
import 'package:ziggle/app/modules/write/gallery_item_button.dart';
import 'package:ziggle/gen/strings.g.dart';

class ImagesPicker extends StatelessWidget {
  final List<XFile> images;
  final void Function(List<XFile>) changeImages;
  final loading = false.obs;

  ImagesPicker({
    super.key,
    required this.images,
    required this.changeImages,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(_build);
  }

  Widget _build() {
    if (!loading.value && images.isEmpty) {
      return ZiggleButton(
        text: t.write.images.action,
        onTap: _selectPhotos,
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
      return Obx(() => GalleryItemButton(
            file: images[index],
            onRemove: loading.value ? null : () => _removeImage(index),
          ));
    }
    return SizedBox(
      width: 144,
      child: Obx(() => loading.value
          ? const ZiggleButton(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ZiggleButton(text: '+', onTap: _selectPhotos)),
    );
  }

  void _selectPhotos() async {
    AnalyticsService.to.logTrySelectImage();
    loading.value = true;
    final result = await ImagePicker().pickMultiImage();
    changeImages([...images, ...result]);
    loading.value = false;
    AnalyticsService.to.logSelectImage();
  }

  void _removeImage(int index) {
    changeImages(images.whereIndexed((i, _) => i != index).toList());
  }
}
