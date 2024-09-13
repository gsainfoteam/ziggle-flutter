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
import 'package:ziggle/app/modules/notice/presentation/widgets/photo_item.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeWriteBodyPage extends StatefulWidget {
  const NoticeWriteBodyPage({super.key});

  @override
  State<NoticeWriteBodyPage> createState() => _NoticeWriteBodyPageState();
}

class _NoticeWriteBodyPageState extends State<NoticeWriteBodyPage> {
  final _controller = QuillController.basic();
  final _titleFocusNode = FocusNode();
  final _bodyFocusNode = FocusNode();
  String _title = '';
  final List<File> _photos = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    _titleFocusNode.addListener(() => setState(() {}));
    _bodyFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _titleFocusNode.dispose();
    _bodyFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actionDisabled =
        _title.isEmpty || _controller.plainTextEditingValue.text.trim().isEmpty;
    return Scaffold(
      appBar: ZiggleAppBar(
        leading: ZiggleBackButton(label: t.common.cancel),
        title: Text(t.notice.write.title),
        actions: [
          ZiggleButton(
            type: ZiggleButtonType.text,
            disabled: actionDisabled,
            onPressed: actionDisabled ? null : () {},
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
            KeyboardActionsItem(
              focusNode: _titleFocusNode,
            ),
            KeyboardActionsItem(
              focusNode: _bodyFocusNode,
              displayArrows: false,
              toolbarAlignment: MainAxisAlignment.start,
              toolbarButtons: _buildToolbarButtons(),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ZiggleInput(
                focusNode: _titleFocusNode,
                showBorder: false,
                hintText: t.notice.write.titleHint,
                onChanged: (v) => setState(() => _title = v),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: QuillEditor.basic(
                  focusNode: _bodyFocusNode,
                  controller: _controller,
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
            if (!_titleFocusNode.hasFocus && !_bodyFocusNode.hasFocus) ...[
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
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (image == null) return;
                          setState(() => _photos.add(File(image.path)));
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

  List<ButtonBuilder> _buildToolbarButtons() {
    return [
      (_) => _buildToggleButton(
            attribute: Attribute.h1,
            child: Assets.icons.heading.svg(),
          ),
      (_) => _buildToggleButton(
            attribute: Attribute.h2,
            child: Assets.icons.subheading.svg(),
          ),
      (_) => _buildToggleButton(
            attribute: Attribute.bold,
            child: Assets.icons.bold.svg(),
          ),
      (_) => _buildToggleButton(
            attribute: Attribute.italic,
            child: Assets.icons.italic.svg(),
          ),
      (_) => QuillToolbarLinkStyleButton(
            controller: _controller,
            options: QuillToolbarLinkStyleButtonOptions(
              childBuilder: (options, extraOptions) => _buildIcon(
                onPressed: () {
                  showCupertinoDialog<QuillTextLink>(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => _LinkDialog(controller: _controller),
                  ).then((link) => link?.submit(_controller));
                  options.afterButtonPressed?.call();
                },
                isToggled: QuillTextLink.isSelected(_controller),
                child: Assets.icons.link.svg(),
              ),
            ),
          ),
      (_) => _buildToggleButton(
            attribute: Attribute.ul,
            child: Assets.icons.list.svg(),
          ),
      (_) => _buildToggleButton(
            attribute: Attribute.underline,
            child: Assets.icons.underline.svg(),
          ),
    ];
  }

  Widget _buildToggleButton({
    required Attribute<dynamic> attribute,
    required Widget child,
  }) =>
      QuillToolbarToggleStyleButton(
        attribute: attribute,
        controller: _controller,
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
