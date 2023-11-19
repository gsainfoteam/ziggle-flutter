import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown/markdown.dart' hide Text;
import 'package:textfield_tags/textfield_tags.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/common/presentaion/widgets/button.dart';
import 'package:ziggle/app/common/presentaion/widgets/checkbox_label.dart';
import 'package:ziggle/app/common/presentaion/widgets/label.dart';
import 'package:ziggle/app/common/presentaion/widgets/text_form_field.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/core/routes/routes.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:ziggle/app/modules/notices/domain/entities/content_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_write_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/tag_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/write/write_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/images_picker.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/notice_preview_sheet.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeWritePage extends StatelessWidget {
  const NoticeWritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<WriteBloc>()..add(const WriteEvent.init()),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<WriteBloc, WriteState>(
              listenWhen: (_, current) => current.missing,
              listener: (context, state) {
                final title = state.mapOrNull(
                  titleMissing: (_) => t.write.title.error.title,
                  typeMissing: (_) => t.write.type.error.title,
                  bodyMissing: (_) => t.write.body.error.title,
                )!;
                final description = state.mapOrNull(
                  titleMissing: (_) => t.write.title.error.description,
                  typeMissing: (_) => t.write.type.error.description,
                  bodyMissing: (_) => t.write.body.error.description,
                )!;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Column(children: [Text(title), Text(description)]),
                  ),
                );
              },
            ),
            BlocListener<WriteBloc, WriteState>(
              listenWhen: (_, current) => current.error,
              listener: (context, state) => state.whenOrNull(
                error: (reason) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(reason)),
                ),
              ),
            ),
            BlocListener<WriteBloc, WriteState>(
              listenWhen: (_, current) => current.success,
              listener: (context, state) {
                context
                  ..pop()
                  ..push(Paths.articleDetail, extra: state.resultSummary);
              },
            ),
          ],
          child: BlocBuilder<WriteBloc, WriteState>(
            builder: (context, state) => state.maybeMap(
              initial: (_) => const SizedBox.shrink(),
              orElse: () => const _Layout(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  late final NoticeWriteEntity _saved = context.read<WriteBloc>().state.notice;
  late String _title = _saved.title;
  late bool _hasDeadline = _saved.deadline != null;
  late final DateTime _now = DateTime.now();
  late DateTime _deadline = [_saved.deadline ?? _now, _now].max;
  List<XFile> _images = [];
  late NoticeType? _type = _saved.type;
  late String _body = _saved.body;
  final _textFieldTagsController = TextfieldTagsController();
  final _tags = <String>[];
  late final Timer _saveTimer;

  NoticeWriteEntity get writing => NoticeWriteEntity(
        title: _title,
        body: markdownToHtml(_body),
        type: _type,
        deadline: _hasDeadline ? _deadline : null,
        tags: _tags,
        imagePaths: _images.map((e) => e.path).toList(),
      );

  @override
  void initState() {
    super.initState();
    _textFieldTagsController.addListener(_tagListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      for (final tag in _saved.tags) {
        _textFieldTagsController.addTag = tag;
      }
    });
    _saveTimer = Timer.periodic(const Duration(seconds: 5), _autoSave);
  }

  void _tagListener() {
    final tags = _textFieldTagsController.getTags ?? [];
    _tags.clear();
    for (final tag in tags) {
      if (tag.startsWith('#')) {
        _textFieldTagsController.removeTag = tag;
        _textFieldTagsController.addTag = tag.substring(1);
        continue;
      }
      if (_tags.contains(tag)) {
        _textFieldTagsController.removeTag = tag;
      } else {
        _tags.add(tag);
      }
    }
  }

  void _autoSave(Timer timer) {
    context.read<WriteBloc>().add(WriteEvent.save(writing));
  }

  @override
  void dispose() {
    _textFieldTagsController
      ..removeListener(_tagListener)
      ..dispose();
    _saveTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: _buildMeta(),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: _buildBody(),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: _buildFooter(),
          ),
        ],
      ),
    );
  }

  Column _buildMeta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          initialValue: _title,
          onChanged: (value) => _title = value,
          style: TextStyles.articleWriterTitleStyle,
          decoration: InputDecoration.collapsed(
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            hintText: t.write.title.placeholder,
          ),
        ),
        CheckboxLabel(
          label: t.write.deadline.label,
          checked: _hasDeadline,
          onChanged: (v) => setState(() => _hasDeadline = v),
        ),
        const SizedBox(height: 10),
        _hasDeadline
            ? Column(
                children: [
                  SizedBox(
                    height: 144,
                    child: CupertinoDatePicker(
                      initialDateTime: _deadline,
                      minimumDate: _now,
                      onDateTimeChanged: (v) => _deadline = v,
                      mode: CupertinoDatePickerMode.dateAndTime,
                      dateOrder: DatePickerDateOrder.ymd,
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              )
            : const SizedBox.shrink(),
        Label(icon: Icons.sort, label: t.write.type.label),
        const SizedBox(height: 10),
        _buildTypes(),
        const SizedBox(height: 20),
        Label(icon: Icons.sell, label: t.write.tags.label),
        const SizedBox(height: 10),
        _buildTags()
      ],
    );
  }

  LayoutBuilder _buildTags() {
    return LayoutBuilder(
      builder: (context, constraints) => TextFieldTags(
        textSeparators: const [' ', ','],
        textfieldTagsController: _textFieldTagsController,
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
                                    (tag) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Chip(
                                        label: Text(tag),
                                        onDeleted: () => onTagDelete(tag),
                                      ),
                                    ),
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
            (type) => ZiggleButton(
              onTap: () => setState(() => _type = type),
              text: type.label,
              color: _type == type ? Palette.primaryColor : Palette.light,
              textStyle: TextStyles.defaultStyle.copyWith(
                color: _type == type ? Palette.white : null,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          )
          .toList(),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                icon: Icons.menu,
                label: t.write.body.write(language: t.write.body.korean),
              ),
              const SizedBox(height: 10),
              ZiggleTextFormField(
                initialValue: _body,
                onChanged: (v) => _body = v,
                hintText: t.write.body.placeholder,
                minLines: 11,
                maxLines: 20,
              ),
              const SizedBox(height: 32),
              Label(
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
          ),
        ),
        ImagesPicker(
          images: _images,
          changeImages: (v) => setState(() => _images = v),
        ),
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
            onTap: () {
              sl<AnalyticsRepository>().logPreviewArticle();
              showModalBottomSheet(
                context: context,
                enableDrag: false,
                backgroundColor: Palette.white,
                isScrollControlled: true,
                builder: (context) => NoticePreviewSheet(
                  notice: NoticeEntity(
                    id: 0,
                    contents: [
                      ContentEntity(
                        id: 0,
                        createdAt: DateTime.now(),
                        title: _title,
                        body: markdownToHtml(_body),
                        deadline: _hasDeadline ? _deadline : null,
                      ),
                    ],
                    author: context.read<AuthBloc>().state.user!.name,
                    createdAt: DateTime.now(),
                    tags: _tags.map((e) => TagEntity(0, e)).toList(),
                    views: 0,
                    reminder: false,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 250,
          height: 50,
          child: BlocBuilder<WriteBloc, WriteState>(
            builder: (context, state) => ZiggleButton(
              text: t.write.submit,
              onTap: () =>
                  context.read<WriteBloc>().add(WriteEvent.write(writing)),
              loading: state.whenOrNull(writing: () => true) ?? false,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              fontSize: 20,
            ),
          ),
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
