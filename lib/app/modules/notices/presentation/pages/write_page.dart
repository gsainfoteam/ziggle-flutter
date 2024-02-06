import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/tag_entity.dart';
import '../../domain/enums/notice_type.dart';
import '../bloc/tag_bloc.dart';

class WritePage extends StatelessWidget {
  const WritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<TagBloc>()),
      ],
      child: const _Layout(),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  DateTime? _deadline;
  NoticeType? _type;
  String? _korean;
  String? _english;
  bool get _done => _type != null && _korean != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Theme.of(context).appBarTheme.toolbarHeight,
        title: Text(t.notice.write.title),
        actions: [
          ZiggleButton(
            onTap: _done ? () {} : null,
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              t.notice.write.action,
              style: TextStyle(
                color: _done ? Palette.primary100 : Palette.textGrey,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextFormField(
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isCollapsed: true,
                  hintText: t.notice.write.titleHint,
                  hintStyle: const TextStyle(color: Palette.textGrey),
                ),
              ),
            ),
            const Divider(indent: 18, endIndent: 18, height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        t.notice.write.deadline,
                        style: TextStyle(
                          fontSize: 16,
                          color: _deadline == null
                              ? Palette.textGrey
                              : Palette.primary100,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                        value: _deadline != null,
                        onChanged: (_) => setState(
                          () => _deadline =
                              _deadline == null ? DateTime.now() : null,
                        ),
                        activeColor: Palette.primary100,
                      ),
                    ],
                  ),
                  if (_deadline != null)
                    SizedBox(
                      height: 150,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        initialDateTime: _deadline,
                        onDateTimeChanged: (v) => setState(() => _deadline = v),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(indent: 18, endIndent: 18, height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Assets.icons.list.svg(),
                  const SizedBox(width: 6),
                  Text(
                    t.notice.write.type,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 52,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final type = NoticeType.writable[index];
                  final selected = _type == type;
                  return ZiggleButton(
                    color:
                        selected ? Palette.black : Palette.backgroundGreyLight,
                    onTap: () => setState(() => _type = type),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(children: [
                      type.icon.svg(
                        colorFilter: selected
                            ? const ColorFilter.mode(
                                Palette.white,
                                BlendMode.srcIn,
                              )
                            : null,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        type.name,
                        style: TextStyle(
                          color: selected ? Palette.white : Palette.black,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ]),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: NoticeType.writable.length,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Assets.icons.tag.svg(),
                  const SizedBox(width: 6),
                  Text.rich(
                    t.notice.write.tag.title(
                      optional: (v) => TextSpan(
                        text: v,
                        style: const TextStyle(color: Palette.textGrey),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: _Tag(),
            ),
            const Divider(indent: 18, endIndent: 18),
            Column(
              children: [
                _WriteArticleButton(
                  onTap: () => WriteArticleRoute(
                    title: t.notice.write.writeKorean,
                    hint: t.notice.write.enterKorean,
                    $extra: _korean ?? '',
                  ).push<String>(context).then((value) {
                    if (!mounted) return;
                    setState(() => _korean = value ?? _korean);
                  }),
                  title: Text(
                    t.notice.write.korean,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  isFilled: _korean != null,
                ),
                _WriteArticleButton(
                  onTap: () => WriteArticleRoute(
                    title: t.notice.write.writeEnglish,
                    hint: t.notice.write.enterEnglish,
                    $extra: _english ?? '',
                  ).push<String>(context).then((value) {
                    if (!mounted) return;
                    setState(() => _english = value ?? _english);
                  }),
                  title: Text.rich(
                    t.notice.write.english(
                      optional: (v) => TextSpan(
                        text: v,
                        style: const TextStyle(color: Palette.textGrey),
                      ),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  isFilled: _english != null,
                ),
              ],
            ),
            const Divider(indent: 18, endIndent: 18),
          ],
        ),
      ),
    );
  }
}

class _WriteArticleButton extends StatelessWidget {
  const _WriteArticleButton({
    required this.onTap,
    required this.title,
    required this.isFilled,
  });

  final VoidCallback onTap;
  final Widget title;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18),
      leading: Assets.icons.docs.svg(),
      title: title,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isFilled ? t.notice.write.edit : t.notice.write.write,
            style: const TextStyle(
              fontSize: 14,
              color: Palette.textGrey,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Palette.textGrey,
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatefulWidget {
  const _Tag();

  @override
  State<_Tag> createState() => _TagState();
}

class _TagState extends State<_Tag> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  String _text = '';
  String? _currentQuery;
  int? _currentCursor;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChange);
    _focus.addListener(_onChange);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onChange)
      ..dispose();
    _focus
      ..removeListener(_onChange)
      ..dispose();
    super.dispose();
  }

  void _onChange() {
    final text = _controller.text;
    // if newly focused, add a hash
    if (_focus.hasFocus && !_hasFocus) {
      _hasFocus = true;
      _controller.text = '$text #'.trim();
      return;
    }
    _hasFocus = _focus.hasFocus;

    // if focused and empty, add a hash
    if (text.isEmpty && _focus.hasFocus) {
      _controller.text = '#';
      return;
    }

    // when unfocused, remove the last hash and the space / add missing hash
    if (!_focus.hasFocus) {
      _controller.text = text.removeSuffix('#').cleanupTags();
      return;
    }

    // remove prefix space
    if (text.startsWith(' ')) {
      _controller.value =
          _controller.value.replaced(const TextRange(start: 0, end: 1), '');
      return;
    }

    // add prefix hash
    if (!text.startsWith('#') && _hasFocus) {
      _controller.value =
          _controller.value.replaced(const TextRange(start: 0, end: 0), '#');
      return;
    }

    // check selection is collapsed
    final offset = switch (_controller.selection) {
      TextSelection(isCollapsed: true, baseOffset: final v, isValid: true) => v,
      _ => null,
    };
    if (offset == null) return;

    final edited = text != _text;
    final prevText = _text;
    _text = text;
    if (!edited) return;

    // if tried to add new tag(space) without complete previous one, remove the space
    if (text.substring(max(offset - 2, 0), offset).contains('# ')) {
      _controller.value = _controller.value
          .replaced(TextRange(start: offset - 1, end: offset), '');
      return;
    }

    // if tried to add new space, add a hash after the space
    if (text.safeSubstring(offset - 1, offset).contains(' ') &&
        prevText.safeSubstring(offset - 1, offset) != ' ') {
      _controller.value = _controller.value
          .replaced(TextRange(start: offset, end: offset), '#');
      return;
    }

    // remove the second hash or space
    if (text.contains('##') || text.contains('  ')) {
      _controller.value = _controller.value.copyWith(
        composing: TextRange.empty,
        text: text.replaceAll('##', '#').replaceAll('  ', ' '),
        selection: TextSelection.collapsed(offset: offset - 1),
      );
      return;
    }

    final word = text.substring(0, offset).split(' ').last;
    final query = word.split('#').last;
    if (query == _currentQuery) return;
    _currentQuery = query;
    _currentCursor = offset;
    context
        .read<TagBloc>()
        .add(query.isEmpty ? const TagEvent.reset() : TagEvent.search(query));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<TagEntity>(
        textEditingController: _controller,
        focusNode: _focus,
        optionsBuilder: (_) async {
          if (_currentQuery == null) return [];
          final bloc = context.read<TagBloc>();
          try {
            await bloc.stream.firstWhere((s) => s.loaded);
            return bloc.state.tags;
          } on StateError {
            return [];
          }
        },
        displayStringForOption: (v) =>
            '${_text.substring(0, _currentCursor! - _currentQuery!.length)}'
                    '${v.name} '
                    '${_text.substring(_currentCursor!)}'
                .cleanupTags(),
        optionsViewBuilder: (context, onSelected, options) => Align(
          alignment: Alignment.topLeft,
          child: Material(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Palette.backgroundGreyLight,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 200,
                maxWidth: constraints.maxWidth,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final tag = options.elementAt(index);
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: index == 0
                            ? const Radius.circular(10)
                            : Radius.zero,
                        bottom: index == options.length - 1
                            ? const Radius.circular(10)
                            : Radius.zero,
                      ),
                    ),
                    leading: Assets.icons.hashtag.svg(),
                    title: Text(tag.name),
                    onTap: () => onSelected(tag),
                  );
                },
              ),
            ),
          ),
        ),
        fieldViewBuilder: (_, c, fn, ofs) => TextFormField(
          controller: c,
          focusNode: fn,
          onFieldSubmitted: (_) => ofs(),
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: Palette.primary100,
                width: 1.5,
              ),
            ),
            hintText: t.notice.write.tag.hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            hintStyle: const TextStyle(color: Palette.textGrey),
          ),
        ),
      ),
    );
    // return ;
  }
}

extension on String {
  String safeSubstring(int start, int end) {
    return substring(max(start, 0), min(end, length));
  }

  String removeSuffix(String suffix) {
    return endsWith(suffix)
        ? substring(0, length - 1).removeSuffix(suffix)
        : this;
  }

  String cleanupTags() =>
      trim().splitMapJoin(RegExp(' (#?)'), onMatch: (m) => ' #').trim();
}
