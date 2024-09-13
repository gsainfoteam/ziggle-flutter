import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_back_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/notice/presentation/widgets/language_toggle.dart';
import 'package:ziggle/app/modules/notice/presentation/widgets/photo_item.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeWriteBodyPage extends StatefulWidget {
  const NoticeWriteBodyPage({super.key});

  @override
  State<NoticeWriteBodyPage> createState() => _NoticeWriteBodyPageState();
}

class _NoticeWriteBodyPageState extends State<NoticeWriteBodyPage>
    with SingleTickerProviderStateMixin {
  final _koreanTitleController = TextEditingController();
  final _koreanBodyController = QuillController.basic();
  final _koreanTitleFocusNode = FocusNode();
  final _koreanBodyFocusNode = FocusNode();
  final _englishTitleController = TextEditingController();
  final _englishBodyController = QuillController.basic();
  final _englishTitleFocusNode = FocusNode();
  final _englishBodyFocusNode = FocusNode();
  final List<File> _photos = [];
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    _koreanTitleController.addListener(() => setState(() {}));
    _koreanBodyController.addListener(() => setState(() {}));
    _koreanTitleFocusNode.addListener(() => setState(() {}));
    _koreanBodyFocusNode.addListener(() => setState(() {}));
    _englishTitleController.addListener(() => setState(() {}));
    _englishBodyController.addListener(() => setState(() {}));
    _englishTitleFocusNode.addListener(() => setState(() {}));
    _englishBodyFocusNode.addListener(() => setState(() {}));
    _tabController.addListener(() => setState(() {
          _koreanBodyFocusNode.unfocus();
          _koreanTitleFocusNode.unfocus();
          _englishBodyFocusNode.unfocus();
          _englishTitleFocusNode.unfocus();
        }));
  }

  @override
  void dispose() {
    super.dispose();
    _koreanTitleController.dispose();
    _koreanBodyController.dispose();
    _koreanTitleFocusNode.dispose();
    _koreanBodyFocusNode.dispose();
    _englishTitleController.dispose();
    _englishBodyController.dispose();
    _englishTitleFocusNode.dispose();
    _englishBodyFocusNode.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actionDisabled = _koreanTitleController.text.trim().isEmpty ||
        _koreanBodyController.plainTextEditingValue.text.trim().isEmpty ||
        (_tabController.index == 1 &&
            (_englishTitleController.text.trim().isEmpty ||
                _englishBodyController.plainTextEditingValue.text
                    .trim()
                    .isEmpty));
    return Scaffold(
      appBar: ZiggleAppBar(
        leading: ZiggleBackButton(label: t.common.cancel),
        title: Text(t.notice.write.title),
        actions: [
          ZiggleButton.text(
            disabled: actionDisabled,
            onPressed: actionDisabled
                ? null
                : () => const NoticeWriteRoute(NoticeWriteStep.config)
                    .push(context),
            child: Text(
              t.common.done,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: KeyboardActions(
        disableScroll: true,
        config: KeyboardActionsConfig(
          keyboardBarElevation: 0,
          keyboardSeparatorColor: Palette.grayBorder,
          keyboardBarColor: Palette.white,
          actions: [
            KeyboardActionsItem(focusNode: _koreanTitleFocusNode),
            KeyboardActionsItem(
              focusNode: _koreanBodyFocusNode,
              displayArrows: false,
              toolbarAlignment: MainAxisAlignment.start,
              toolbarButtons: _buildToolbarButtons(_koreanBodyController),
            ),
            KeyboardActionsItem(focusNode: _englishTitleFocusNode),
            KeyboardActionsItem(
              focusNode: _englishBodyFocusNode,
              displayArrows: false,
              toolbarAlignment: MainAxisAlignment.start,
              toolbarButtons: _buildToolbarButtons(_englishBodyController),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  LanguageToggle(
                      onToggle: (v) => _tabController.animateTo(v ? 1 : 0),
                      value: _tabController.index != 0),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _Editor(
                    titleFocusNode: _koreanTitleFocusNode,
                    bodyFocusNode: _koreanBodyFocusNode,
                    titleController: _koreanTitleController,
                    bodyController: _koreanBodyController,
                  ),
                  _Editor(
                    onTranslate: _englishBodyController
                            .plainTextEditingValue.text
                            .trim()
                            .isNotEmpty
                        ? null
                        : () {},
                    titleFocusNode: _englishTitleFocusNode,
                    bodyFocusNode: _englishBodyFocusNode,
                    titleController: _englishTitleController,
                    bodyController: _englishBodyController,
                  ),
                ],
              ),
            ),
            if (!_koreanTitleFocusNode.hasFocus &&
                !_koreanBodyFocusNode.hasFocus &&
                !_englishTitleFocusNode.hasFocus &&
                !_englishBodyFocusNode.hasFocus) ...[
              const SizedBox(height: 10),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (index == _photos.length) {
                      return GestureDetector(
                        onTap: () async {
                          final images = await ImagePicker().pickMultiImage();
                          if (!mounted) return;
                          setState(() => _photos.addAll(
                                images.map((e) => File(e.path)),
                              ));
                        },
                        child: DottedBorder(
                          color: Palette.gray,
                          strokeWidth: 2,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          borderPadding: const EdgeInsets.all(1),
                          dashPattern: const [10, 4],
                          child: SizedBox(
                            width: 140,
                            height: 140,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Assets.icons.addPhoto.svg(width: 50),
                                const SizedBox(height: 5),
                                Text(
                                  t.notice.write.addPhoto,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Palette.grayText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return PhotoItem(
                      onDelete: () => setState(() => _photos.removeAt(index)),
                      image: FileImage(_photos[index]),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemCount: _photos.length + 1,
                ),
              ),
            ],
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  List<ButtonBuilder> _buildToolbarButtons(QuillController controller) {
    return [
      (_) => _buildToggleButton(
            controller: controller,
            attribute: Attribute.h1,
            child: Assets.icons.heading.svg(),
          ),
      (_) => _buildToggleButton(
            controller: controller,
            attribute: Attribute.h2,
            child: Assets.icons.subheading.svg(),
          ),
      (_) => _buildToggleButton(
            controller: controller,
            attribute: Attribute.bold,
            child: Assets.icons.bold.svg(),
          ),
      (_) => _buildToggleButton(
            controller: controller,
            attribute: Attribute.italic,
            child: Assets.icons.italic.svg(),
          ),
      (_) => QuillToolbarLinkStyleButton(
            controller: controller,
            options: QuillToolbarLinkStyleButtonOptions(
              childBuilder: (options, extraOptions) => _buildIcon(
                onPressed: () {
                  showCupertinoDialog<QuillTextLink>(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => _LinkDialog(controller: controller),
                  ).then((link) => link?.submit(controller));
                  options.afterButtonPressed?.call();
                },
                isToggled: QuillTextLink.isSelected(controller),
                child: Assets.icons.link.svg(),
              ),
            ),
          ),
      (_) => _buildToggleButton(
            controller: controller,
            attribute: Attribute.ul,
            child: Assets.icons.list.svg(),
          ),
      (_) => _buildToggleButton(
            controller: controller,
            attribute: Attribute.underline,
            child: Assets.icons.underline.svg(),
          ),
    ];
  }

  Widget _buildToggleButton({
    required Attribute<dynamic> attribute,
    required Widget child,
    required QuillController controller,
  }) =>
      QuillToolbarToggleStyleButton(
        attribute: attribute,
        controller: controller,
        options: QuillToolbarToggleStyleButtonOptions(
          childBuilder: (options, extraOptions) => _buildIcon(
            onPressed: extraOptions.onPressed,
            isToggled: extraOptions.isToggled,
            child: child,
          ),
        ),
      );

  Widget _buildIcon({
    required VoidCallback? onPressed,
    required bool isToggled,
    required Widget child,
  }) =>
      GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isToggled ? Palette.primary.withOpacity(0.4) : null,
          ),
          child: child,
        ),
      );
}

class _Editor extends StatelessWidget {
  const _Editor({
    required this.titleFocusNode,
    required this.bodyFocusNode,
    required this.titleController,
    required this.bodyController,
    this.onTranslate,
  });

  final FocusNode titleFocusNode;
  final FocusNode bodyFocusNode;
  final TextEditingController titleController;
  final QuillController bodyController;
  final VoidCallback? onTranslate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: ZiggleInput(
            controller: titleController,
            focusNode: titleFocusNode,
            showBorder: false,
            hintText: t.notice.write.titleHint,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Container(height: 1, color: Palette.grayBorder),
        ),
        const SizedBox(height: 10),
        if (onTranslate != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                ZiggleButton.big(
                  emphasize: false,
                  onPressed: onTranslate,
                  child: Row(
                    children: [
                      Assets.icons.sparks.svg(),
                      const SizedBox(width: 10),
                      Text(t.notice.write.translate),
                    ],
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: QuillEditor.basic(
              focusNode: bodyFocusNode,
              controller: bodyController,
              configurations: QuillEditorConfigurations(
                placeholder: t.notice.write.bodyHint,
                padding: const EdgeInsets.symmetric(vertical: 10),
                customStyles: const DefaultStyles(
                  placeHolder: DefaultTextBlockStyle(
                    TextStyle(fontSize: 16, color: Palette.gray),
                    HorizontalSpacing.zero,
                    VerticalSpacing.zero,
                    VerticalSpacing.zero,
                    null,
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

class _LinkDialog extends StatefulWidget {
  const _LinkDialog({
    required QuillController controller,
  }) : _controller = controller;

  final QuillController _controller;

  @override
  State<_LinkDialog> createState() => _LinkDialogState();
}

class _LinkDialogState extends State<_LinkDialog> {
  late final _initialTextLink = QuillTextLink.prepare(widget._controller);
  late final _text = TextEditingController(text: _initialTextLink.text);
  late final _link = TextEditingController(text: _initialTextLink.link ?? '');

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoTextField(
            placeholder: t.notice.write.link.text,
            controller: _text,
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 8),
          CupertinoTextField(
            placeholder: t.notice.write.link.link,
            controller: _link,
            onChanged: (v) => setState(() {}),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: _text.text.isEmpty ||
                  _link.text.isEmpty ||
                  !const AutoFormatMultipleLinksRule()
                      .oneLineLinkRegExp
                      .hasMatch(_link.text)
              ? null
              : () => Navigator.pop(
                    context,
                    QuillTextLink(_text.text, _link.text),
                  ),
          child: _initialTextLink.link == null
              ? Text(t.notice.write.link.add)
              : Text(t.notice.write.link.change),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(
            context,
            QuillTextLink(_text.text, null),
          ),
          child: Text(t.notice.write.link.remove),
        ),
      ],
    );
  }
}
