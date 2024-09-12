import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_back_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
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
  final _focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar(
        leading: ZiggleBackButton(label: t.common.cancel),
        title: Text(t.notice.write.title),
        actions: [
          ZiggleButton(
            type: ZiggleButtonType.text,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            const SizedBox(height: 10),
            ZiggleInput(
              hintText: t.notice.write.titleHint,
              showBorder: false,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(height: 1, color: Palette.grayBorder),
            const SizedBox(height: 20),
            Expanded(
              child: KeyboardActions(
                config: KeyboardActionsConfig(
                  keyboardBarElevation: 0,
                  keyboardSeparatorColor: Palette.grayBorder,
                  keyboardBarColor: Palette.white,
                  actions: [
                    KeyboardActionsItem(
                      focusNode: _focusNode,
                      displayArrows: false,
                      toolbarAlignment: MainAxisAlignment.start,
                      toolbarButtons: _buildToolbarButtons(),
                    ),
                  ],
                ),
                child: QuillEditor.basic(
                  focusNode: _focusNode,
                  controller: _controller,
                  configurations: QuillEditorConfigurations(
                    placeholder: t.notice.write.bodyHint,
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
