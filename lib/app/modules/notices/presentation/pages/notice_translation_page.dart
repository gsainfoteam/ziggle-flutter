import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown/markdown.dart' hide Text;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ziggle/app/common/presentaion/widgets/button.dart';
import 'package:ziggle/app/common/presentaion/widgets/label.dart';
import 'package:ziggle/app/common/presentaion/widgets/text_form_field.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_entity.dart';
import '../bloc/write/write_bloc.dart';

class NoticeTranslationPage extends StatelessWidget {
  final NoticeEntity notice;
  const NoticeTranslationPage({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WriteBloc>(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<WriteBloc, WriteState>(
            listenWhen: (_, current) => current.missing,
            listener: (context, state) {
              final title = state.mapOrNull(
                bodyMissing: (_) => t.write.body.error.title,
              )!;
              final description = state.mapOrNull(
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
            listener: (context, state) => context.pop(),
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text(t.article.settings.writeTranslation),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _Layout(notice: notice),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Layout extends StatefulWidget {
  final NoticeEntity notice;
  const _Layout({required this.notice});

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  String _title = '';
  String _body = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Label(icon: Icons.menu, label: t.write.title.korean),
        const SizedBox(height: 10),
        Text(widget.notice.contents.korean.title!),
        const SizedBox(height: 10),
        Label(icon: Icons.menu, label: t.write.body.korean),
        SelectionArea(
          child: Html(
            data: widget.notice.contents.korean.body,
            style: {'body': Style(margin: Margins.zero)},
          ),
        ),
        Label(
          icon: Icons.menu,
          label: t.write.title.placeholder(language: t.write.title.english),
        ),
        const SizedBox(height: 10),
        ZiggleTextFormField(
          initialValue: _title,
          onChanged: (v) => _title = v,
          hintText: t.write.title.placeholder(language: t.write.title.english),
        ),
        const SizedBox(height: 10),
        Label(
          icon: Icons.menu,
          label: t.write.body.write(language: t.write.body.english),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _TranslateButton(content: widget.notice.contents.localed.body),
          ],
        ),
        const SizedBox(height: 10),
        ZiggleTextFormField(
          onChanged: (v) => _body = v,
          hintText: t.write.body.placeholder,
          minLines: 11,
          maxLines: 20,
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 50,
              child: BlocBuilder<WriteBloc, WriteState>(
                builder: (context, state) => ZiggleButton(
                  loading: state.whenOrNull(writing: () => true) ?? false,
                  onTap: () => context.read<WriteBloc>().add(
                        WriteEvent.translate(
                          widget.notice,
                          _title,
                          markdownToHtml(_body),
                        ),
                      ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  text: t.write.additional.submit,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              child: BlocBuilder<WriteBloc, WriteState>(
                builder: (context, state) => ZiggleButton(
                  loading: state.whenOrNull(writing: () => true) ?? false,
                  onTap: () => context.pop(),
                  color: Palette.secondaryText,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  text: t.write.additional.cancel,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _TranslateButton extends StatelessWidget {
  final String content;
  const _TranslateButton({required this.content});

  @override
  Widget build(BuildContext context) {
    final body = content.replaceAll('/', '\\/');
    return ZiggleButton(
      color: const Color(0xff042b48),
      child: Text.rich(
        t.write.body.translate(
          deepl: WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: SizedBox(
              width: 50,
              child: Transform.scale(
                scale: 2,
                child: SvgPicture.asset(
                  Assets.images.deepl,
                  height: 24,
                  colorFilter:
                      const ColorFilter.mode(Palette.white, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
      ),
      onTap: () =>
          launchUrlString('https://www.deepl.com/translator#ko/en/$body'),
    );
  }
}
