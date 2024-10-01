import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/modules/common/presentation/functions/noop.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_bottom_sheet.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_toggle_button.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_write_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/deadline_selector.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/language_toggle.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class WriteAdditionalNoticePage extends StatefulWidget {
  const WriteAdditionalNoticePage({super.key});

  @override
  State<WriteAdditionalNoticePage> createState() =>
      _WriteAdditionalNoticePageState();
}

class _WriteAdditionalNoticePageState extends State<WriteAdditionalNoticePage>
    with
        SingleTickerProviderStateMixin,
        AutoRouteAwareStateMixin<WriteAdditionalNoticePage> {
  @override
  void didPush() =>
      AnalyticsRepository.pageView(AnalyticsEvent.noticeEditAdditional(
          context.read<NoticeBloc>().state.entity!.id));
  @override
  void didPopNext() =>
      AnalyticsRepository.pageView(AnalyticsEvent.noticeEditAdditional(
          context.read<NoticeBloc>().state.entity!.id));

  late final _prevNotice = context.read<NoticeBloc>().state.entity!;
  late final _draft = context.read<NoticeWriteBloc>().state.draft;
  DateTime? _deadline;
  late final _content =
      TextEditingController(text: _draft.additionalContent[AppLocale.ko] ?? '');
  late final _enContent = _prevNotice.langs.contains(AppLocale.en)
      ? TextEditingController(
          text: _draft.additionalContent[AppLocale.en] ?? '')
      : null;
  late final _tabController = TabController(
    length: _enContent != null ? 2 : 1,
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    _tabController.addListener(() {
      setState(noop);
    });
    _content.addListener(() => setState(noop));
    _enContent?.addListener(() => setState(noop));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _content.dispose();
    _enContent?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: context.t.common.cancel,
        from: PageSource.noticeEditAdditional,
        title: Text(context.t.notice.write.configTitle),
        actions: [
          ZiggleButton.text(
            disabled:
                _content.text.isEmpty || (_enContent?.text.isEmpty ?? false),
            onPressed:
                _content.text.isEmpty || (_enContent?.text.isEmpty ?? false)
                    ? null
                    : () {
                        context.read<NoticeWriteBloc>().add(
                              NoticeWriteEvent.addAdditional(
                                deadline: _deadline,
                                contents: {
                                  AppLocale.ko: _content.text,
                                  if (_enContent != null)
                                    AppLocale.en: _enContent.text,
                                },
                              ),
                            );
                        context.maybePop();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_prevNotice.currentDeadline != null) _buildDeadline(),
              if (_enContent != null) ...[
                if (_prevNotice.currentDeadline != null)
                  const SizedBox(height: 20),
                LanguageToggle(
                  onToggle: (v) => _tabController.animateTo(v ? 1 : 0),
                  value: _tabController.index != 0,
                ),
              ],
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ZiggleInput(
                      controller: _content,
                      maxLines: null,
                      showBorder: false,
                      hintText: context.t.notice.write.bodyHint,
                    ),
                    if (_enContent != null)
                      ZiggleInput(
                        controller: _enContent,
                        maxLines: null,
                        showBorder: false,
                        hintText: context.t.notice.write.bodyHint,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeadline() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Palette.grayLight,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Assets.icons.clock.svg(),
              const SizedBox(width: 6),
              Text.rich(
                context.t.notice.edit.additional.deadline(
                  small: (text) => TextSpan(
                    text: text,
                    style: const TextStyle(
                      color: Palette.gray,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Palette.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              ZiggleToggleButton(
                value: _deadline != null,
                onToggle: (v) async {
                  if (_deadline != null) {
                    setState(() => _deadline = null);
                    return;
                  }
                  final dateTime = await ZiggleBottomSheet.show<DateTime>(
                    context: context,
                    title: context.t.notice.write.deadline.title,
                    builder: (context) => DeadlineSelector(
                      initialDateTime: _prevNotice.currentDeadline!.toLocal(),
                      onChanged: (v) => Navigator.pop(context, v),
                    ),
                  );
                  if (dateTime == null || !mounted) return;
                  setState(() => _deadline = dateTime);
                },
              ),
            ],
          ),
          if (_deadline != null) ...[
            const SizedBox(height: 10),
            ZigglePressable(
              onPressed: () async {
                final dateTime = await ZiggleBottomSheet.show<DateTime>(
                  context: context,
                  title: context.t.notice.write.deadline.title,
                  builder: (context) => DeadlineSelector(
                    initialDateTime: _deadline,
                    onChanged: (v) => Navigator.pop(context, v),
                  ),
                );
                if (dateTime == null || !mounted) return;
                setState(() => _deadline = dateTime);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Palette.grayBorder),
                ),
                child: Center(
                  child: Text(
                    DateFormat.yMd().add_jm().format(_deadline!),
                    style: const TextStyle(
                      color: Palette.grayText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
