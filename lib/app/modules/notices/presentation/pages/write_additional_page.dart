import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_entity.dart';
import '../bloc/write_bloc.dart';

class WriteAdditionalPage extends StatelessWidget {
  const WriteAdditionalPage({super.key, required this.notice});

  final NoticeEntity notice;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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

  final NoticeEntity notice;

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  DateTime? _deadline;
  String _korean = '';
  String _english = '';
  bool get _englishRequired => widget.notice.langs.contains(AppLocale.en);
  bool get _done =>
      _korean.isNotEmpty && (!_englishRequired || _english.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.notice.write.additional),
        actions: [
          ZiggleButton(
            onTap: _done
                ? () async {
                    final blob = context.read<WriteBloc>();
                    blob.add(WriteEvent.writeAdditional(
                      notice: widget.notice,
                      content: _korean,
                      deadline: _deadline ?? widget.notice.currentDeadline,
                    ));
                    final result =
                        await blob.stream.firstWhere((s) => s.isLoaded);
                    if (!_englishRequired) {
                      if (!context.mounted) return;
                      context.pop(result.notice);
                      return;
                    }
                    blob.add(WriteEvent.writeForeign(
                      notice: result.notice,
                      content: _english,
                      contentId:
                          maxBy(result.notice.additionalContents, (c) => c.id)!
                              .id,
                    ));
                    final s = await blob.stream.firstWhere((s) => s.isLoaded);
                    if (!context.mounted) return;
                    context.pop(s.notice);
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            children: [
              if (widget.notice.currentDeadline != null)
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
              if (widget.notice.currentDeadline != null)
                const Divider(height: 40),
              Row(
                children: [
                  Assets.icons.docs.svg(),
                  const SizedBox(width: 6),
                  Text(
                    t.notice.write.korean,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                onChanged: (v) => setState(() => _korean = v),
                maxLines: 10,
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
                  hintText: t.notice.write.enterKorean,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  hintStyle: const TextStyle(color: Palette.textGrey),
                ),
              ),
              if (_englishRequired) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Assets.icons.docs.svg(),
                    const SizedBox(width: 6),
                    Text(
                      t.notice.write.english,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onChanged: (v) => setState(() => _english = v),
                  maxLines: 10,
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
                    hintText: t.notice.write.enterEnglish,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    hintStyle: const TextStyle(color: Palette.textGrey),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
