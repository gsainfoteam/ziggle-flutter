import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class WriteArticlePage extends StatefulWidget {
  const WriteArticlePage({
    super.key,
    required this.title,
    required this.initialContent,
    required this.hintText,
  });

  final String title;
  final String initialContent;
  final String hintText;

  @override
  State<WriteArticlePage> createState() => _WriteArticlePageState();
}

class _WriteArticlePageState extends State<WriteArticlePage> {
  late final _controller = TextEditingController(text: widget.initialContent);
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget _adaptiveAction({
    required BuildContext context,
    required VoidCallback onPressed,
    required Widget child,
  }) {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return TextButton(onPressed: onPressed, child: child);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoDialogAction(onPressed: onPressed, child: child);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.initialContent == _controller.text,
      onPopInvoked: (didPop) => showAdaptiveDialog(
        context: context,
        builder: (dialogContext) => AlertDialog.adaptive(
          title: Text(t.notice.write.unsaved.title),
          actions: [
            _adaptiveAction(
              context: dialogContext,
              onPressed: () => context
                ..pop()
                ..pop(),
              child: Text(t.notice.write.unsaved.discard),
            ),
            _adaptiveAction(
              context: dialogContext,
              onPressed: () => dialogContext.pop(),
              child: Text(t.notice.write.unsaved.preserve),
            ),
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            ZiggleButton(
              onTap: () => context.pop(_controller.text),
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                t.notice.write.action,
                style: const TextStyle(color: Palette.primary100),
              ),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverSafeArea(
              sliver: SliverFillRemaining(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: KeyboardActions(
                    config: KeyboardActionsConfig(actions: [
                      KeyboardActionsItem(
                          focusNode: _focusNode,
                          displayArrows: false,
                          toolbarAlignment: MainAxisAlignment.start,
                          toolbarButtons: [
                            (node) => TextButton(
                                  onPressed: () {},
                                  child: const Text('test'),
                                ),
                            (node) => TextButton(
                                  onPressed: () {},
                                  child: const Text('test'),
                                ),
                            (node) => TextButton(
                                  onPressed: () {},
                                  child: const Text('test'),
                                ),
                            (node) => TextButton(
                                  onPressed: () {},
                                  child: const Text('test'),
                                ),
                            (node) => TextButton(
                                  onPressed: () {},
                                  child: const Text('test'),
                                ),
                          ]),
                    ]),
                    child: TextFormField(
                      focusNode: _focusNode,
                      autofocus: true,
                      maxLines: null,
                      controller: _controller,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.hintText,
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
}
