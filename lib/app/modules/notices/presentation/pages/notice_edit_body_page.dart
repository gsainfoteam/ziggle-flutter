import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_back_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/ai_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_write_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/extensions/quill.dart';
import 'package:ziggle/app/modules/notices/presentation/functions/quill.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/edit_deadline.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/language_toggle.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class NoticeEditBodyPage extends StatelessWidget {
  const NoticeEditBodyPage({super.key, this.showEnglish = false});

  final bool showEnglish;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AiBloc>(),
      child: BlocListener<AiBloc, AiState>(
        listener: (context, state) => state.mapOrNull(
          error: (error) => context.showToast(error.message),
        ),
        child: _Layout(showEnglish: showEnglish),
      ),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout({this.showEnglish = false});

  final bool showEnglish;

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> with SingleTickerProviderStateMixin {
  late final _prevNotice = context.read<NoticeBloc>().state.entity!;
  late final _draft = context.read<NoticeWriteBloc>().state.draft;
  late final _koreanTitleController = TextEditingController(
      text: _draft.titles[AppLocale.ko] ??
          _prevNotice.titles[AppLocale.ko] ??
          '');
  late final _koreanBodyController = QuillController(
    document: documentFromHtml(_draft.bodies[AppLocale.ko] ??
        _prevNotice.contents[AppLocale.ko] ??
        '<br/>'),
    selection: const TextSelection.collapsed(offset: 0),
    readOnly: _prevNotice.isPublished,
  );
  final _koreanTitleFocusNode = FocusNode();
  final _koreanBodyFocusNode = FocusNode();
  late final _englishTitleController = TextEditingController(
      text: _draft.titles[AppLocale.en] ??
          _prevNotice.titles[AppLocale.en] ??
          '');
  late final _englishBodyController = QuillController(
    document: documentFromHtml(_draft.bodies[AppLocale.en] ??
        _prevNotice.contents[AppLocale.en] ??
        '<br/>'),
    selection: const TextSelection.collapsed(offset: 0),
    readOnly: _prevNotice.contents[AppLocale.en] != null,
  );
  final _englishTitleFocusNode = FocusNode();
  final _englishBodyFocusNode = FocusNode();
  late final _tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: widget.showEnglish ? 1 : 0,
  );

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
    _koreanTitleController.dispose();
    _koreanBodyController.dispose();
    _koreanTitleFocusNode.dispose();
    _koreanBodyFocusNode.dispose();
    _englishTitleController.dispose();
    _englishBodyController.dispose();
    _englishTitleFocusNode.dispose();
    _englishBodyFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _next() {
    _save();
    context.maybePop();
  }

  void _save() {
    final bloc = context.read<NoticeWriteBloc>()
      ..add(NoticeWriteEvent.setTitle(_koreanTitleController.text))
      ..add(NoticeWriteEvent.setBody(_koreanBodyController.html));
    if (_englishTitleController.text.isNotEmpty) {
      bloc
        ..add(
          NoticeWriteEvent.setTitle(_englishTitleController.text, AppLocale.en),
        )
        ..add(NoticeWriteEvent.setBody(
          _englishBodyController.html,
          AppLocale.en,
        ));
    }
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
        leading: ZiggleBackButton(label: context.t.common.cancel),
        title: Text(
          _tabController.index == 0
              ? context.t.notice.edit.title
              : context.t.notice.write.title,
        ),
        actions: [
          ZiggleButton.text(
            disabled: actionDisabled,
            onPressed: actionDisabled ? null : _next,
            child: Text(
              context.t.common.done,
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
            if (!_prevNotice.isPublished) ...[
              KeyboardActionsItem(focusNode: _koreanTitleFocusNode),
              KeyboardActionsItem(
                focusNode: _koreanBodyFocusNode,
                displayArrows: false,
                toolbarAlignment: MainAxisAlignment.start,
                toolbarButtons: _buildToolbarButtons(_koreanBodyController),
              ),
            ],
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
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 6),
              child: EditDeadline(
                deadline:
                    _prevNotice.createdAt.add(const Duration(minutes: 15)),
              ),
            ),
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
                    titleDisabled: true,
                    titleFocusNode: _koreanTitleFocusNode,
                    bodyFocusNode: _koreanBodyFocusNode,
                    titleController: _koreanTitleController,
                    bodyController: _koreanBodyController,
                  ),
                  _Editor(
                    titleDisabled: _prevNotice.contents[AppLocale.en] != null,
                    onTranslate: _englishBodyController
                            .plainTextEditingValue.text
                            .trim()
                            .isNotEmpty
                        ? null
                        : () async {
                            final bloc = context.read<AiBloc>();
                            final blocker =
                                bloc.stream.firstWhere((s) => s.hasResult);
                            bloc.add(AiEvent.request(
                              body: _koreanBodyController.html,
                              lang: AppLocale.en,
                            ));
                            final result = await blocker;
                            result.mapOrNull(
                              loaded: (result) =>
                                  _englishBodyController.html = result.body,
                            );
                          },
                    titleFocusNode: _englishTitleFocusNode,
                    bodyFocusNode: _englishBodyFocusNode,
                    titleController: _englishTitleController,
                    bodyController: _englishBodyController,
                  ),
                ],
              ),
            ),
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
    required this.titleDisabled,
  });

  final FocusNode titleFocusNode;
  final FocusNode bodyFocusNode;
  final TextEditingController titleController;
  final QuillController bodyController;
  final VoidCallback? onTranslate;
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
            child: Opacity(
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
            placeholder: context.t.notice.write.link.text,
            controller: _text,
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 8),
          CupertinoTextField(
            placeholder: context.t.notice.write.link.link,
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
              ? Text(context.t.notice.write.link.add)
              : Text(context.t.notice.write.link.change),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(
            context,
            QuillTextLink(_text.text, null),
          ),
          child: Text(context.t.notice.write.link.remove),
        ),
      ],
    );
  }
}
