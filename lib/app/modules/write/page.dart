import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/global_widgets/text_form_field.dart';
import 'package:ziggle/app/modules/write/controller.dart';
import 'package:ziggle/app/modules/write/gallery_item_button.dart';

class WritePage extends GetView<WriteController> {
  const WritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMeta().paddingSymmetric(vertical: 30, horizontal: 20),
          const Divider(),
          _buildBody().paddingSymmetric(vertical: 30),
          const Divider(),
          _buildFooter().paddingSymmetric(vertical: 20),
        ],
      ),
    );
  }

  Column _buildMeta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          onChanged: controller.title,
          style: TextStyles.articleWriterTitleStyle,
          decoration: const InputDecoration.collapsed(
            border: OutlineInputBorder(borderSide: BorderSide.none),
            hintText: '제목을 입력하세요',
          ),
        ),
        Row(
          children: [
            Obx(() => Checkbox.adaptive(
                  value: controller.hasDeadline.value,
                  onChanged: controller.hasDeadline,
                )),
            const Text('마감일 설정', style: TextStyles.secondaryLabelStyle),
          ],
        ),
        const SizedBox(height: 10),
        Obx(
          () => controller.hasDeadline.value
              ? Column(
                  children: [
                    SizedBox(
                      height: 144,
                      child: CupertinoDatePicker(
                        minimumDate: DateTime.now(),
                        onDateTimeChanged: controller.deadline,
                        mode: CupertinoDatePickerMode.date,
                        dateOrder: DatePickerDateOrder.ymd,
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        const _Label(icon: Icons.sort, label: '분류'),
        const SizedBox(height: 10),
        _buildTypes(),
        const SizedBox(height: 20),
        const _Label(icon: Icons.sell, label: '태그 설정'),
        const SizedBox(height: 10),
        const ZiggleTextFormField(hintText: '태그를 입력하세요 (띄어쓰기로 구분)')
      ],
    );
  }

  Widget _buildTypes() {
    return Wrap(
      spacing: 8,
      children: ArticleType.values
          .sublist(0, 3)
          .map(
            (type) => Obx(
              () => ZiggleButton(
                onTap: () => controller.selectedType(type),
                text: type.label,
                color: controller.selectedType.value == type
                    ? Palette.primaryColor
                    : Palette.light,
                textStyle: TextStyles.defaultStyle.copyWith(
                  color: controller.selectedType.value == type
                      ? Palette.white
                      : null,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Label(icon: Icons.menu, label: '본문 내용 입력'),
            const SizedBox(height: 10),
            ZiggleTextFormField(
              onChanged: controller.body,
              hintText: '본문 내용을 입력하세요\n마크다운 문법을 지원합니다.',
              minLines: 11,
              maxLines: 20,
            ),
            const SizedBox(height: 32),
            const _Label(icon: Icons.add_photo_alternate, label: '사진 첨부'),
            const SizedBox(height: 2),
            const Text(
              '선택 후 클릭하여 대표 사진을 선택해주세요.',
              style: TextStyle(color: Palette.secondaryText),
            ),
            const SizedBox(height: 12),
          ],
        ).paddingSymmetric(horizontal: 20),
        Obx(_buildGallery),
      ],
    );
  }

  Widget _buildGallery() {
    if (controller.images.isEmpty) {
      return ZiggleButton(
        text: '폰에서 사진 선택하기...',
        onTap: controller.selectPhotos,
      );
    }
    return SizedBox(
      height: 144,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        clipBehavior: Clip.none,
        itemCount: controller.images.length + 1,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 4),
        itemBuilder: _galleryItemBuilder,
      ),
    );
  }

  Widget _galleryItemBuilder(BuildContext context, int index) {
    if (index < controller.images.length) {
      return Obx(
        () => GalleryItemButton(
          file: controller.images[index],
          isMain: controller.images[index] == controller.mainImage.value,
          onTap: () => controller.setMainImage(index),
          onRemove: () => controller.removeImage(index),
        ),
      );
    }
    return SizedBox(
      width: 144,
      child: ZiggleButton(text: '+', onTap: controller.selectPhotos),
    );
  }

  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
          child: ZiggleButton(
            text: '공지 미리보기',
            color: Colors.transparent,
            onTap: controller.showPreview,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 250,
          height: 50,
          child: ZiggleButton(
            text: '공지 제출하기',
            onTap: controller.submit,
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '공지 제출 시 수정 및 삭제가 불가능합니다.',
          style: TextStyle(fontSize: 14, color: Palette.secondaryText),
        ),
        const SizedBox(height: 150),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({
    required this.icon,
    required this.label,
  });

  final IconData? icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 4),
        Text(label, style: TextStyles.label),
      ],
    );
  }
}
