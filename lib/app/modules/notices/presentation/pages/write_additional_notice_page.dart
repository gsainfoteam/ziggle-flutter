import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/common/presentation/functions/noop.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_write_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/language_toggle.dart';
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
      TextEditingController(text: _draft.additionalContent[Language.ko] ?? '');
  late final _enContent = _prevNotice.langs.contains(Language.en)
      ? TextEditingController(text: _draft.additionalContent[Language.en] ?? '')
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
    return BlocListener<NoticeBloc, NoticeState>(
      listener: (context, state) {
        state.mapOrNull(
          error: (error) => context.showToast(error.message),
        );
      },
      child: Scaffold(
        appBar: ZiggleAppBar.compact(
          backLabel: context.t.common.cancel,
          from: PageSource.noticeEditAdditional,
          title: Text(context.t.notice.write.configTitle),
          actions: [
            ZiggleButton.text(
              disabled:
                  _content.text.isEmpty || (_enContent?.text.isEmpty ?? false),
              onPressed: () {
                if (_content.text.isEmpty ||
                    (_enContent?.text.isEmpty ?? false)) {
                  return;
                }
                context.read<NoticeWriteBloc>().add(
                      NoticeWriteEvent.addAdditional(
                        deadline: _deadline,
                        contents: {
                          Language.ko: _content.text,
                          if (_enContent != null) Language.en: _enContent.text,
                        },
                      ),
                    );
                context.maybePop();
                AnalyticsRepository.action(
                    const AnalyticsEvent.noticeEditAdditionalDone());
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
                if (_enContent != null) ...[
                  if (_prevNotice.currentDeadline != null)
                    const SizedBox(height: 20),
                  LanguageToggle(
                    onToggle: (v) {
                      AnalyticsRepository.click(
                        AnalyticsEvent.noticeEditAdditionalToggleLanguage(
                            v ? Language.en : Language.ko),
                      );
                      _tabController.animateTo(v ? 1 : 0);
                    },
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
      ),
    );
  }
}
