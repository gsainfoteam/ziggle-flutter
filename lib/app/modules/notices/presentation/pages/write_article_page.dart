import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  late String _content = widget.initialContent;

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
      canPop: widget.initialContent == _content,
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
              onTap: () => context.pop(_content),
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                t.notice.write.action,
                style: const TextStyle(color: Palette.primary100),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: TextFormField(
                initialValue: _content,
                onChanged: (value) => setState(() => _content = value),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hintText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
