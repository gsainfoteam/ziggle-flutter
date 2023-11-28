import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/common/presentaion/widgets/button.dart';
import 'package:ziggle/app/common/presentaion/widgets/checkbox_label.dart';
import 'package:ziggle/app/common/presentaion/widgets/label.dart';
import 'package:ziggle/app/common/presentaion/widgets/text_form_field.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_entity.dart';
import '../bloc/write/write_bloc.dart';

class NoticeAdditionalPage extends StatelessWidget {
  final NoticeEntity notice;
  const NoticeAdditionalPage({super.key, required this.notice});

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
            title: Text(t.article.settings.additional),
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
  String _body = '';
  String _englishBody = '';
  DateTime? _deadline;
  late final DateTime _minDeadline = [
    if (widget.notice.currentDeadline != null) widget.notice.currentDeadline!,
    DateTime.now()
  ].max;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Label(icon: Icons.menu, label: t.write.body.korean),
        SelectionArea(
          child: Html(
            data: widget.notice.contents.korean.body,
            style: {'body': Style(margin: Margins.zero)},
          ),
        ),
        if (widget.notice.contents.english != null) ...[
          Label(icon: Icons.menu, label: t.write.body.english),
          SelectionArea(
            child: Html(
              data: widget.notice.contents.english!.body,
              style: {'body': Style(margin: Margins.zero)},
            ),
          ),
        ],
        if (widget.notice.currentDeadline != null)
          CheckboxLabel(
            label: t.write.deadline.delay,
            checked: _deadline != null,
            onChanged: (v) => setState(
              () => _deadline = v ? _minDeadline : null,
            ),
          ),
        if (_deadline != null)
          SizedBox(
            height: 144,
            child: CupertinoDatePicker(
              initialDateTime: _deadline,
              minimumDate: _minDeadline,
              mode: CupertinoDatePickerMode.dateAndTime,
              dateOrder: DatePickerDateOrder.ymd,
              onDateTimeChanged: (v) => _deadline = v,
            ),
          ),
        Label(icon: Icons.menu, label: t.write.additional.korean),
        const SizedBox(height: 10),
        ZiggleTextFormField(
          onChanged: (v) => _body = v,
          hintText: t.write.additional.placeholder,
          minLines: 11,
          maxLines: 20,
        ),
        if (widget.notice.contents.english != null) ...[
          const SizedBox(height: 10),
          Label(icon: Icons.menu, label: t.write.additional.english),
          const SizedBox(height: 10),
          ZiggleTextFormField(
            onChanged: (v) => _englishBody = v,
            hintText: t.write.additional.placeholder,
            minLines: 11,
            maxLines: 20,
          ),
        ],
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
                        WriteEvent.additional(
                            widget.notice,
                            _body,
                            widget.notice.contents.english != null
                                ? _englishBody
                                : null,
                            _deadline ?? widget.notice.currentDeadline),
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
