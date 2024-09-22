import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class Editor extends StatelessWidget {
  const Editor({
    super.key,
    required this.titleFocusNode,
    required this.bodyFocusNode,
    required this.titleController,
    required this.bodyController,
    this.onTranslate,
    this.translating = false,
    this.titleDisabled = false,
  });

  final FocusNode titleFocusNode;
  final FocusNode bodyFocusNode;
  final TextEditingController titleController;
  final QuillController bodyController;
  final VoidCallback? onTranslate;
  final bool translating;
  final bool titleDisabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: ZiggleInput(
            disabled: titleDisabled,
            controller: titleController,
            focusNode: titleFocusNode,
            showBorder: false,
            hintText: context.t.notice.write.titleHint,
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
                      Text(context.t.notice.write.translate),
                    ],
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: translating
                ? const CircularProgressIndicator()
                : Opacity(
                    opacity: bodyController.readOnly ? 0.5 : 1,
                    child: QuillEditor.basic(
                      focusNode: bodyFocusNode,
                      controller: bodyController,
                      configurations: QuillEditorConfigurations(
                        placeholder: context.t.notice.write.bodyHint,
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
        ),
      ],
    );
  }
}
