import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_write_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/edit_deadline.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class NoticeEditPage extends StatelessWidget {
  const NoticeEditPage({super.key});

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
                  deadline:
                      state.entity!.createdAt.add(const Duration(minutes: 15)),
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
                      state.entity!.contents[AppLocale.en] != null,
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
                  disabled: false,
                  icon: Assets.icons.add,
                  title: context.t.notice.edit.additional.action,
                  onPressed: () {
                    AnalyticsRepository.click(
                        AnalyticsEvent.noticeEditAdditional(
                            context.read<NoticeBloc>().state.entity!.id));
                    const WriteAdditionalNoticeRoute().push(context);
                  },
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
  });

  final SvgGenImage icon;
  final String title;
  final VoidCallback onPressed;
  final bool disabled;

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
                fontWeight: FontWeight.w600,
                color: disabled ? Palette.gray : Palette.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
