import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown/markdown.dart' show markdownToHtml;
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/enums/notice_type.dart';
import '../bloc/tag_bloc.dart';
import '../bloc/write_bloc.dart';

class WritePage extends StatelessWidget {
  const WritePage({super.key, this.notice});

  final NoticeEntity? notice;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<TagBloc>()),
        BlocProvider(create: (_) => sl<WriteBloc>()),
      ],
      child: BlocConsumer<WriteBloc, WriteState>(
        listener: (context, state) => state.mapOrNull(
          error: (value) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(value.message)),
          ),
        ),
        builder: (context, state) => Stack(
          children: [
            IgnorePointer(ignoring: state.isLoading, child: _Layout(notice)),
            IgnorePointer(
              child: TweenAnimationBuilder(
                tween: Tween(
                  begin: state.isLoading ? 0.0 : 1.0,
                  end: state.isLoading ? 1.0 : 0.0,
                ),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: child,
                ),
                duration: const Duration(milliseconds: 100),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    child: const Center(child: CircularProgressIndicator()),
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

class _Layout extends StatefulWidget {
  const _Layout(this.notice);

  final NoticeEntity? notice;

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  late String _title = widget.notice?.title ?? '';
  late DateTime? _deadline = widget.notice?.deadline;
  late NoticeType? _type = widget.notice == null
      ? null
      : NoticeType.tags.firstWhereOrNull(
          (e) => widget.notice!.tags.contains(e.name),
        );
  late List<String> _tags = widget.notice?.tags
          .whereNot((element) => NoticeType.tags.any((e) => e.name == element))
          .toList() ??
      [];
  late String? _article = widget.notice?.content;
  late final List<String> _prevImages = widget.notice?.imageUrls.toList() ?? [];
  final List<File> _images = [];
  bool get _done => _title.isNotEmpty && _type != null && _article != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Theme.of(context).appBarTheme.toolbarHeight,
        title: Text(widget.notice == null
            ? t.notice.write.title
            : t.notice.write.modify),
        actions: [
          ZiggleButton(
            onTap: _done
                ? () async {
                    final blob = context.read<WriteBloc>();
                    blob.add(WriteEvent.write(
                      title: _title,
                      content: markdownToHtml(_article!),
                      deadline: _deadline,
                      type: _type!,
                      images: _images,
                      tags: _tags,
                    ));
                    final s = await blob.stream.firstWhere((s) => s.isLoaded);
                    if (!mounted) return;
                    context.pop();
                    NoticeRoute.fromEntity(s.notice).push(context);
                  }
                : null,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextFormField(
                initialValue: _title,
                onChanged: (v) => setState(() => _title = v),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: _Tags(
                onChanged: (tags) => _tags = tags.sublist(0),
                initialTags: _tags,
              ),
            ),
            const Divider(indent: 18, endIndent: 18),
            ListTile(
              onTap: () => WriteArticleRoute.create(
                title: t.notice.write.writeKorean,
                hint: t.notice.write.enterKorean,
                body: _article,
              ).push<String>(context).then((value) {
                if (!mounted) return;
                setState(() => _article = value ?? _article);
              }),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18),
              leading: Assets.icons.docs.svg(),
              horizontalTitleGap: 6,
              title: Text(
                t.notice.write.korean,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _article != null
                        ? t.notice.write.edit
                        : t.notice.write.write,
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
            ),
            const Divider(indent: 18, endIndent: 18),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Assets.icons.mediaImagePlus.svg(),
                  const SizedBox(width: 6),
                  Text.rich(
                    t.notice.write.images(
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
            if (_prevImages.isEmpty && _images.isEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: ZiggleButton(
                  onTap: _addImages,
                  text: t.notice.write.selectImage,
                ),
              )
            else
              SizedBox(
                height: 170,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (index == _prevImages.length + _images.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: SizedBox(
                          width: 130,
                          child: ZiggleButton(
                            onTap: _addImages,
                            color: Colors.transparent,
                            padding: EdgeInsets.zero,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              color: Palette.textGrey,
                              strokeWidth: 2,
                              dashPattern: const [10, 4],
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Assets.icons.mediaImagePlus.svg(
                                      width: 60,
                                      colorFilter: const ColorFilter.mode(
                                        Palette.textGrey,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    Text(
                                      t.notice.write.addImage,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20) +
                              const EdgeInsets.only(right: 16),
                          child: Image(
                            image: index < _prevImages.length
                                ? NetworkImage(_prevImages[index])
                                : FileImage(_images[index - _prevImages.length])
                                    as ImageProvider,
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 0,
                          child: Stack(
                            children: [
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: ZiggleButton(
                                  onTap: () {
                                    if (!mounted) return;
                                    setState(() => index < _prevImages.length
                                        ? _prevImages.removeAt(index)
                                        : _images.removeAt(
                                            index - _prevImages.length));
                                  },
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.zero,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Palette.textGreyDark,
                                      ),
                                      child: const Icon(Icons.close, size: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: _prevImages.length + _images.length + 1,
                ),
              )
          ],
        ),
      ),
    );
  }

  void _addImages() async {
    final analytics = sl<AnalyticsRepository>();
    analytics.logTrySelectImage();
    final result = await ImagePicker().pickMultiImage();
    if (!mounted) return;
    setState(() {
      _images.addAll(result.map((e) => File(e.path)).toList());
    });
    analytics.logSelectImage();
  }
}

class _Tags extends StatefulWidget {
  const _Tags({required this.onChanged, required this.initialTags});

  final List<String> initialTags;
  final void Function(List<String>)? onChanged;

  @override
  State<_Tags> createState() => _TagsState();
}

class _TagsState extends State<_Tags> {
  late final _controller = TextEditingController(
    text: widget.initialTags.map((e) => '#$e').join(' '),
  );
  final _focus = FocusNode();
  String _text = '';
  String? _currentQuery;
  int? _currentCursor;
  bool _hasFocus = false;
  final _textController = StreamController<String>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChange);
    _focus.addListener(_onChange);
    _textController.stream.debounceTime(Duration.zero).listen(_onChangeHandler);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onChange)
      ..dispose();
    _focus
      ..removeListener(_onChange)
      ..dispose();
    _textController.close();
    super.dispose();
  }

  void _onChange() {
    _textController.add(_controller.text);
  }

  void _onChangeHandler(_) {
    final text = _controller.text;
    widget.onChanged?.call(text
        .split(' ')
        .where((v) => v.startsWith('#'))
        .map((e) => e.substring(1).trim())
        .where((element) => element.isNotEmpty)
        .toList());

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
