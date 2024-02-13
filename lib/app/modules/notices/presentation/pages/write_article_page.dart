import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../widgets/adaptive_dialog_action.dart';

const _urlPattern =
    r'https?://(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_+.~#?&//=]*)';

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
  final _textController = StreamController<String>();
  TextEditingValue _previous = const TextEditingValue();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _textController.add(_controller.text));
    _textController.stream.debounceTime(Duration.zero).listen(_onChangeHandler);
  }

  @override
  void dispose() {
    _textController.close();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChangeHandler(String text) {
    final changedSelection = _controller.selection
        .copyWith(baseOffset: _previous.selection.baseOffset);
    final previous = _previous;
    _previous = _controller.value;
    if (text == previous.text) return;
    if (!_controller.selection.isCollapsed) return;
    if (changedSelection.base.affinity == TextAffinity.upstream) return;
    final lastLine = TextSelection(
      baseOffset: previous._lineStart,
      extentOffset: changedSelection.extentOffset,
    );
    _changeLink(lastLine);
  }

  void _changeLink(TextSelection selection) {
    if (selection.base.affinity == TextAffinity.upstream) return;
    final text = selection.textInside(_controller.text);
    final match = RegExp(_urlPattern).allMatches(text).firstOrNull;
    if (match == null) return;
    final doNotAfter = RegExp(r'(\]\(|\[)');
    final before = text.safeSubstring(0, match.start);
    final doNotBefore = RegExp(r'([A-Za-z\w)]|\]\()');
    final after = text.safeSubstring(match.end);
    if (doNotAfter.hasMatch(before)) {
      return;
    }
    if (after.isEmpty || doNotBefore.matchAsPrefix(after) != null) {
      return;
    }
    final linkSelection = selection.copyWith(
      baseOffset: selection.baseOffset + match.start,
      extentOffset: selection.baseOffset + match.end,
    );
    final link = match.group(0)!;
    final markdownLink =
        '[${link.length > 30 ? '${link.substring(0, 30)}...' : link}]($link)';
    _controller.value = _controller.value.replaced(linkSelection, markdownLink);
    _changeLink(linkSelection.copyWith(
      baseOffset: linkSelection.baseOffset + markdownLink.length,
      extentOffset: selection.extentOffset - link.length + markdownLink.length,
    ));
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
            AdaptiveDialogAction(
              onPressed: () => context
                ..pop()
                ..pop(),
              child: Text(t.notice.write.unsaved.discard),
            ),
            AdaptiveDialogAction(
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
                  child: _buildField(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  KeyboardActions _buildField() {
    return KeyboardActions(
      config: KeyboardActionsConfig(actions: [
        KeyboardActionsItem(
          focusNode: _focusNode,
          displayArrows: false,
          toolbarAlignment: MainAxisAlignment.start,
          toolbarButtons: [
            (node) => IconButton(
                  onPressed: () => _controller.value =
                      _controller.value._removeAndAddPrefix('#'),
                  icon: Assets.icons.heading.svg(),
                ),
            (node) => IconButton(
                  onPressed: () => _controller.value =
                      _controller.value._removeAndAddPrefix('##'),
                  icon: Assets.icons.subheading.svg(),
                ),
            (node) => IconButton(
                  onPressed: () =>
                      _controller.value = _controller.value._wrapWith('**'),
                  icon: Assets.icons.bold.svg(),
                ),
            (node) => IconButton(
                  onPressed: () =>
                      _controller.value = _controller.value._wrapWith('_'),
                  icon: Assets.icons.italic.svg(),
                ),
            (node) => IconButton(
                  onPressed: () => _controller.value =
                      _controller.value._wrapWith('[', '](https://)'),
                  icon: Assets.icons.link.svg(),
                ),
            (node) => IconButton(
                  onPressed: () => _controller.value =
                      _controller.value._removeAndAddPrefix('-'),
                  icon: Assets.icons.list.svg(),
                ),
            (node) => IconButton(
                  onPressed: () => _controller.value =
                      _controller.value._wrapWith('<u>', '</u>'),
                  icon: Assets.icons.underline.svg(),
                ),
          ],
        ),
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
    );
  }
}

extension on TextEditingValue {
  static const _prefixes = ['#', '##', '-'];

  int get _lineStart {
    final lineStart = text.substring(0, selection.start).lastIndexOf('\n');
    return lineStart + 1;
  }

  String get _prefixOnLine {
    final line = text.substring(_lineStart, selection.start);
    return _prefixes.map((p) => '$p ').firstWhere(
          (prefix) => line.startsWith(prefix),
          orElse: () => '',
        );
  }

  TextEditingValue _removeAndAddPrefix(String prefix) => replaced(
        TextRange(start: _lineStart, end: _lineStart + _prefixOnLine.length),
        _prefixOnLine == '$prefix ' ? '' : '$prefix ',
      );

  TextEditingValue _wrapWith(String prefix, [String? suffix]) => replaced(
        selection,
        '$prefix${selection.textInside(text)}${suffix ?? prefix}',
      ).copyWith(
        selection: TextSelection(
          baseOffset: selection.baseOffset + prefix.length,
          extentOffset: selection.extentOffset + prefix.length,
        ),
      );
}

extension on String {
  String safeSubstring(int start, [int? end]) {
    return substring(max(start, 0), end == null ? null : min(end, length));
  }
}
