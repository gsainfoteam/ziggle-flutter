import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_bottom_sheet.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_write_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/deadline_selector.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/edit_deadline.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class NoticeEditPage extends StatefulWidget {
  const NoticeEditPage({super.key});

  @override
  State<NoticeEditPage> createState() => _NoticeEditPageState();
}

class _NoticeEditPageState extends State<NoticeEditPage>
    with AutoRouteAwareStateMixin<NoticeEditPage> {
  @override
  void didPush() => AnalyticsRepository.pageView(
      AnalyticsEvent.noticeEdit(context.read<NoticeBloc>().state.entity!.id));
  @override
  void didPopNext() => AnalyticsRepository.pageView(
      AnalyticsEvent.noticeEdit(context.read<NoticeBloc>().state.entity!.id));

  late final _prevNotice = context.read<NoticeBloc>().state.entity!;
  late final _draft = context.read<NoticeWriteBloc>().state.draft;
  late final _content =
      TextEditingController(text: _draft.additionalContent[Language.ko] ?? '');
  late final _enContent = _prevNotice.langs.contains(Language.en)
      ? TextEditingController(text: _draft.additionalContent[Language.en] ?? '')
      : null;

  Future<void> _publish(BuildContext context) async {
    final bloc = context.read<NoticeWriteBloc>();
    final blocker = bloc.stream.firstWhere((state) => state.hasResult);
    bloc.add(NoticeWriteEvent.publish(
      context.read<NoticeBloc>().state.entity!,
    ));
    final state = await blocker;
    if (!context.mounted) return;
    context.read<NoticeBloc>().add(const NoticeEvent.getFull());
    state.mapOrNull(
      done: (state) {
        context.maybePop();
      },
      error: (state) => context.showToast(state.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: context.t.common.cancel,
        from: PageSource.noticeEdit,
        title: Text(context.t.notice.edit.title),
        actions: [
          BlocBuilder<NoticeWriteBloc, NoticeWriteState>(
            builder: (context, state) => ZiggleButton.text(
              disabled: !state.hasChanging,
              onPressed: () {
                AnalyticsRepository.click(AnalyticsEvent.noticeEditPublish(
                    context.read<NoticeBloc>().state.entity!.id));
                _publish(context);
              },
              child: Text(context.t.notice.write.publish),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: BlocBuilder<NoticeBloc, NoticeState>(
            builder: (context, state) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EditDeadline(
                  deadline: state.entity!.publishedAt,
                  alreadyPassed: state.entity!.isPublished,
                ),
                const SizedBox(height: 25),
                _ActionButton(
                  disabled: !state.isLoaded || state.entity!.isPublished,
                  icon: Assets.icons.body,
                  title: context.t.notice.edit.editBody,
                  onPressed: () {
                    AnalyticsRepository.click(AnalyticsEvent.noticeEditBody(
                        context.read<NoticeBloc>().state.entity!.id));
                    NoticeEditBodyRoute(showEnglish: false).push(context);
                  },
                ),
                const SizedBox(height: 10),
                _ActionButton(
                  disabled: !state.isLoaded ||
                      state.entity!.contents[Language.en] != null,
                  icon: Assets.icons.language,
                  title: context.t.notice.edit.addEnglish,
                  onPressed: () {
                    AnalyticsRepository.click(AnalyticsEvent.noticeEditEnglish(
                        context.read<NoticeBloc>().state.entity!.id));
                    NoticeEditBodyRoute(showEnglish: true).push(context);
                  },
                ),
                const SizedBox(height: 10),
                _ActionButton(
                  disabled: !state.isLoaded,
                  icon: Assets.icons.add,
                  title: context.t.notice.edit.additional.title,
                  onPressed: () {
                    AnalyticsRepository.click(
                        AnalyticsEvent.noticeEditAdditional(
                            context.read<NoticeBloc>().state.entity!.id));
                    const WriteAdditionalNoticeRoute().push(context);
                  },
                ),
                const SizedBox(height: 10),
                _ActionButton(
                  disabled: !state.isLoaded || state.entity!.deadline == null,
                  icon: Assets.icons.clock,
                  title: context.t.notice.additional.deadline,
                  onPressed: () {
                    ZiggleBottomSheet.show<DateTime?>(
                      context: context,
                      title: context.t.notice.write.deadline.title,
                      builder: (context) => DeadlineSelector(
                        isEditMode: true,
                        onChanged: (v) => Navigator.pop(context, v),
                      ),
                    ).then((dateTime) {
                      if (context.mounted) {
                        context.read<NoticeWriteBloc>().add(
                              NoticeWriteEvent.addAdditional(
                                deadline: dateTime,
                                contents: {
                                  Language.ko: _content.text,
                                  if (_enContent != null)
                                    Language.en: _enContent.text,
                                },
                              ),
                            );
                      }
                    });
                    if (!mounted) return;
                  },
                  deadline: _prevNotice.currentDeadline,
                ),
                const SizedBox(height: 25),
                ZiggleButton.cta(
                  emphasize: false,
                  onPressed: () {
                    AnalyticsRepository.click(AnalyticsEvent.noticeEditPreview(
                        context.read<NoticeBloc>().state.entity!.id));
                    const NoticeEditPreviewRoute().push(context);
                  },
                  child: Text(context.t.notice.write.preview),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.title,
    required this.onPressed,
    required this.disabled,
    this.deadline,
  });

  final SvgGenImage icon;
  final String title;
  final VoidCallback onPressed;
  final bool disabled;
  final DateTime? deadline;

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'No deadline set';
    final year = dateTime.year;
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$year-$month-$day $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return ZigglePressable(
      onPressed: disabled ? null : onPressed,
      decoration: const BoxDecoration(
        color: Palette.grayLight,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
            icon.svg(
              height: 40,
              width: 40,
              colorFilter: disabled
                  ? const ColorFilter.mode(Palette.gray, BlendMode.srcIn)
                  : null,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: disabled ? Palette.gray : Palette.black,
              ),
            ),
            if (deadline != null) ...[
              const SizedBox(height: 5),
              BlocBuilder<NoticeWriteBloc, NoticeWriteState>(
                builder: (context, state) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: state.draft.deadline != null
                        ? Palette.white
                        : Palette.grayMedium,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Palette.grayBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatDateTime(deadline),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Palette.grayText,
                        ),
                      ),
                      if (state.draft.deadline != null)
                        Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Assets.icons.nextArrow.svg(),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              formatDateTime(state.draft.deadline),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Palette.primary,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ],
        ),
      ),
    );
  }
}
