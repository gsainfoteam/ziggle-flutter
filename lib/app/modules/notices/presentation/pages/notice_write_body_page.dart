import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/common/presentation/functions/noop.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_back_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/event_type.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/ai_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_write_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/extensions/quill.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/editor.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/language_toggle.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/link_dialog.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/photo_item.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class NoticeWriteBodyPage extends StatelessWidget {
  const NoticeWriteBodyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AiBloc>(),
      child: BlocListener<AiBloc, AiState>(
        listener: (context, state) => state.mapOrNull(
          error: (error) => context.showToast(error.message),
        ),
        child: const _Layout(),
      ),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> with SingleTickerProviderStateMixin {
  final _koreanTitleController = TextEditingController();
  final _koreanBodyController = QuillController.basic();
  final _koreanTitleFocusNode = FocusNode();
  final _koreanBodyFocusNode = FocusNode();
  final _englishTitleController = TextEditingController();
  final _englishBodyController = QuillController.basic();
  final _englishTitleFocusNode = FocusNode();
  final _englishBodyFocusNode = FocusNode();
  final List<File> _photos = [];
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    _koreanTitleController.addListener(() => setState(noop));
    _koreanBodyController.addListener(() => setState(noop));
    _koreanTitleFocusNode.addListener(() => setState(noop));
    _koreanBodyFocusNode.addListener(() => setState(noop));
    _englishTitleController.addListener(() => setState(noop));
    _englishBodyController.addListener(() => setState(noop));
    _englishTitleFocusNode.addListener(() => setState(noop));
    _englishBodyFocusNode.addListener(() => setState(noop));
    _tabController.addListener(() => setState(() {
          _koreanBodyFocusNode.unfocus();
          _koreanTitleFocusNode.unfocus();
          _englishBodyFocusNode.unfocus();
          _englishTitleFocusNode.unfocus();
        }));
  }

  @override
  void dispose() {
    super.dispose();
    _koreanTitleController.dispose();
    _koreanBodyController.dispose();
    _koreanTitleFocusNode.dispose();
    _koreanBodyFocusNode.dispose();
    _englishTitleController.dispose();
    _englishBodyController.dispose();
    _englishTitleFocusNode.dispose();
    _englishBodyFocusNode.dispose();
    _tabController.dispose();
  }

  void _next() {
    _save();
    const NoticeWriteConfigRoute().push(context);
  }

  void _save() {
    final bloc = context.read<NoticeWriteBloc>()
      ..add(NoticeWriteEvent.setTitle(_koreanTitleController.text))
      ..add(NoticeWriteEvent.setBody(_koreanBodyController.html))
      ..add(NoticeWriteEvent.setImages(_photos));
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
        title: Text(context.t.notice.write.title),
        actions: [
          ZiggleButton.text(
            disabled: actionDisabled,
            onPressed: () {
              AnalyticsRepository.click(const AnalyticsEvent.writeConfig());
              if (!actionDisabled) _next();
            },
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
            KeyboardActionsItem(focusNode: _koreanTitleFocusNode),
            KeyboardActionsItem(
              focusNode: _koreanBodyFocusNode,
              displayArrows: false,
              toolbarAlignment: MainAxisAlignment.start,
              toolbarButtons: _buildToolbarButtons(_koreanBodyController),
            ),
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  LanguageToggle(
                      onToggle: (v) {
                        AnalyticsRepository.click(
                            AnalyticsEvent.writeToggleLanguage(
                                v ? "eng" : "kor"));
                        _tabController.animateTo(v ? 1 : 0);
                      },
                      value: _tabController.index != 0),
                ],
              ),
            ),
            _buildEditors(),
            if (!_koreanTitleFocusNode.hasFocus &&
                !_koreanBodyFocusNode.hasFocus &&
                !_englishTitleFocusNode.hasFocus &&
                !_englishBodyFocusNode.hasFocus) ...[
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
                          AnalyticsRepository.click(
                              const AnalyticsEvent.writeAddPhoto());
                          final images = await ImagePicker().pickMultiImage();
                          if (!mounted) return;
                          setState(() => _photos.addAll(
                                images.map((e) => File(e.path)),
                              ));
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
                                  context.t.notice.write.addPhoto,
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

  Expanded _buildEditors() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Editor(
            titleFocusNode: _koreanTitleFocusNode,
            bodyFocusNode: _koreanBodyFocusNode,
            titleController: _koreanTitleController,
            bodyController: _koreanBodyController,
          ),
          BlocBuilder<AiBloc, AiState>(
            builder: (context, state) => Editor(
              translating: state.isLoading,
              onTranslate: _englishBodyController.plainTextEditingValue.text
                      .trim()
                      .isNotEmpty
                  ? null
                  : _translate,
              titleFocusNode: _englishTitleFocusNode,
              bodyFocusNode: _englishBodyFocusNode,
              titleController: _englishTitleController,
              bodyController: _englishBodyController,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _translate() async {
    final bloc = context.read<AiBloc>();
    final blocker = bloc.stream.firstWhere((s) => s.hasResult);
    bloc.add(AiEvent.request(
      body: _koreanBodyController.html,
      lang: AppLocale.en,
    ));
    final result = await blocker;
    result.mapOrNull(
      loaded: (result) => _englishBodyController.html = result.body,
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
                    builder: (context) => LinkDialog(controller: controller),
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
