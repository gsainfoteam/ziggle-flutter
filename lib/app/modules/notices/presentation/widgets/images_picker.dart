import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/common/presentaion/widgets/button.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/gallery_item_button.dart';
import 'package:ziggle/gen/strings.g.dart';

class ImagesPicker extends StatefulWidget {
  final List<XFile> images;
  final void Function(List<XFile>) changeImages;

  const ImagesPicker({
    super.key,
    required this.images,
    required this.changeImages,
  });

  @override
  State<ImagesPicker> createState() => _ImagesPickerState();
}

class _ImagesPickerState extends State<ImagesPicker> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    if (!_loading && widget.images.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ZiggleButton(
          text: t.write.images.action,
          onTap: _selectPhotos,
        ),
      );
    }
    return SizedBox(
      height: 144,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        clipBehavior: Clip.none,
        itemCount: widget.images.length + 1,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 4),
        itemBuilder: _galleryItemBuilder,
      ),
    );
  }

  Widget _galleryItemBuilder(BuildContext context, int index) {
    if (index < widget.images.length) {
      return GalleryItemButton(
        file: widget.images[index],
        onRemove: _loading ? null : () => _removeImage(index),
      );
    }
    return SizedBox(
      width: 144,
      child: _loading
          ? const ZiggleButton(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ZiggleButton(text: '+', onTap: _selectPhotos),
    );
  }

  void _selectPhotos() async {
    sl<AnalyticsRepository>().logTrySelectImage();
    setState(() => _loading = true);
    final result = await ImagePicker().pickMultiImage();
    widget.changeImages([...widget.images, ...result]);
    setState(() => _loading = false);
    sl<AnalyticsRepository>().logSelectImage();
  }

  void _removeImage(int index) {
    widget.changeImages(
        widget.images.whereIndexed((i, _) => i != index).toList());
  }
}
