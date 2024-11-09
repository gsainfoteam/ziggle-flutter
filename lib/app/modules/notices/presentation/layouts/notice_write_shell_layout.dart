import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/confirm.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_write_bloc.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class NoticeWriteShellLayout extends StatelessWidget {
  const NoticeWriteShellLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NoticeWriteBloc>()..add(NoticeWriteEvent.init()),
      child: _PopScope(),
    );
  }
}

class _PopScope extends StatelessWidget {
  const _PopScope();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoticeWriteBloc, NoticeWriteState>(
      builder: (context, state) => state.isReady
          ? PopScope(
              canPop: !state.draft.hasContents,
              onPopInvokedWithResult: (didPop, result) async {
                if (didPop) return;
                final dialogResult = await context.showDialog<bool>(
                  title: context.t.notice.write.pop.title,
                  content: context.t.notice.write.pop.description,
                  buildActions: (context) => [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(context.t.notice.write.pop.save),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(context.t.notice.write.pop.withoutSave),
                    ),
                    CupertinoDialogAction(
                      textStyle: const TextStyle(color: Palette.gray),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(context.t.notice.write.pop.cancel),
                    ),
                  ],
                );
                if (dialogResult == null || !context.mounted) {
                  AnalyticsRepository.click(
                      AnalyticsEvent.writeContinueWriting());
                  return;
                }
                if (dialogResult) {
                  AnalyticsRepository.click(AnalyticsEvent.writeSaveDraft());
                  final bloc = context.read<NoticeWriteBloc>();
                  final waiter = bloc.stream.firstWhere((v) => v.hasResult);
                  bloc.add(const NoticeWriteEvent.save());
                  await waiter;
                  AnalyticsRepository.click(AnalyticsEvent.writeSaveDraft());
                } else {
                  AnalyticsRepository.click(
                      AnalyticsEvent.writeWithoutSaveDraft());
                }
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const AutoRouter(),
            )
          : const SizedBox(),
    );
  }
}
