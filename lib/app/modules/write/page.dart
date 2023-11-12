import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:ziggle/app/common/presentaion/widgets/button.dart';
import 'package:ziggle/app/common/presentaion/widgets/text_form_field.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/write/controller.dart';
import 'package:ziggle/app/modules/write/images_picker.dart';
import 'package:ziggle/gen/strings.g.dart';

class WritePage extends GetView<WriteController> {
  const WritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMeta().paddingSymmetric(vertical: 30, horizontal: 20),
            const Divider(),
            _buildBody().paddingSymmetric(vertical: 30),
            const Divider(),
            _buildFooter().paddingSymmetric(vertical: 20),
          ],
        ),
      ),
    );
  }

  Column _buildMeta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller.titleController,
          style: TextStyles.articleWriterTitleStyle,
          decoration: InputDecoration.collapsed(
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            hintText: t.write.title.placeholder,
          ),
        ),
        Row(
          children: [
            Obx(() => Checkbox.adaptive(
                  value: controller.hasDeadline.value,
                  onChanged: controller.hasDeadline,
                )),
            Text(t.write.deadline.label, style: TextStyles.secondaryLabelStyle),
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
        _Label(icon: Icons.sort, label: t.write.type.label),
        const SizedBox(height: 10),
        _buildTypes(),
        const SizedBox(height: 20),
        _Label(icon: Icons.sell, label: t.write.tags.label),
        const SizedBox(height: 10),
        _buildTags()
      ],
    );
  }

  LayoutBuilder _buildTags() {
    return LayoutBuilder(
      builder: (context, constraints) => TextFieldTags(
        textSeparators: const [' ', ','],
        textfieldTagsController: controller.textFieldTagsController,
        inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) =>
            (context, sc, tags, onTagDelete) => ZiggleTextFormField(
                  controller: tec,
                  focusNode: fn,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  inputDecoration: InputDecoration(
                    hintText: t.write.tags.placeholder,
                    prefixIconConstraints:
                        BoxConstraints(maxWidth: constraints.maxWidth * 0.6),
                    prefixIcon: tags.isNotEmpty
                        ? SingleChildScrollView(
                            controller: sc,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: tags
                                  .map(
                                    (tag) => Chip(
                                      label: Text(tag),
                                      onDeleted: () => onTagDelete(tag),
                                    ).marginSymmetric(horizontal: 4),
                                  )
                                  .toList(),
                            ),
                          )
                        : null,
                  ),
                ),
      ),
    );
  }

  Widget _buildTypes() {
    return Wrap(
      spacing: 8,
      children: NoticeType.writables
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
            _Label(icon: Icons.menu, label: t.write.body.label),
            const SizedBox(height: 10),
            ZiggleTextFormField(
              controller: controller.bodyController,
              hintText: t.write.body.placeholder,
              minLines: 11,
              maxLines: 20,
            ),
            const SizedBox(height: 32),
            _Label(
              icon: Icons.add_photo_alternate,
              label: t.write.images.label,
            ),
            const SizedBox(height: 2),
            Text(
              t.write.images.description,
              style: const TextStyle(color: Palette.secondaryText),
            ),
            const SizedBox(height: 12),
          ],
        ).paddingSymmetric(horizontal: 20),
        Obx(() => ImagesPicker(
              images: controller.images.toList(),
              changeImages: controller.images,
            )),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
          child: ZiggleButton(
            text: t.write.preview,
            color: Colors.transparent,
            onTap: controller.showPreview,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 250,
          height: 50,
          child: Obx(() => ZiggleButton(
                text: t.write.submit,
                onTap: controller.submit,
                loading: controller.loading.value,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                fontSize: 20,
              )),
        ),
        const SizedBox(height: 12),
        Text(
          t.write.warning,
          style: const TextStyle(fontSize: 14, color: Palette.secondaryText),
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
