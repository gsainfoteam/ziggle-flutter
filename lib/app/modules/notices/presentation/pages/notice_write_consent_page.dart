import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_write_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/consent_item.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class NoticeWriteConsentPage extends StatelessWidget {
  const NoticeWriteConsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoticeWriteBloc, NoticeWriteState>(
      builder: (context, state) => PopScope(
        canPop: !state.isLoading,
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

class _LayoutState extends State<_Layout> {
  bool _notification = false;
  bool _edit = false;
  bool _urgent = false;

  void _publish() async {
    final bloc = context.read<NoticeWriteBloc>();
    final blocker = bloc.stream.firstWhere((state) => state.hasResult);
    bloc.add(const NoticeWriteEvent.publish());
    final state = await blocker;
    state.mapOrNull(
      done: (state) {
        context.router.popUntilRouteWithName(NoticeWriteBodyRoute.name);
        context
          ..replaceRoute(SingleNoticeShellRoute(notice: state.notice))
          ..pushRoute(const DetailRoute());
      },
      error: (state) => context.showToast(state.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ZigglePressable(
                      onPressed: () => context.maybePop(),
                      child: Assets.icons.closeCircle.svg(),
                    ),
                  ],
                ),
                Text(
                  context.t.notice.write.consent.title,
                  style: const TextStyle(
                    fontSize: 26,
                    color: Palette.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ConsentItem(
                  title: context.t.notice.write.consent.notification.title,
                  description:
                      context.t.notice.write.consent.notification.description,
                  isChecked: _notification,
                  onChanged: (v) => setState(() => _notification = v),
                ),
                const SizedBox(height: 10),
                ConsentItem(
                  title: context.t.notice.write.consent.edit.title,
                  description: context.t.notice.write.consent.edit.description,
                  isChecked: _edit,
                  onChanged: (v) => setState(() => _edit = v),
                ),
                const SizedBox(height: 10),
                ConsentItem(
                  title: context.t.notice.write.consent.urgent.title,
                  description:
                      context.t.notice.write.consent.urgent.description,
                  isChecked: _urgent,
                  onChanged: (v) => setState(() => _urgent = v),
                ),
                const SizedBox(height: 24),
                BlocBuilder<NoticeWriteBloc, NoticeWriteState>(
                  builder: (context, state) => ZiggleButton.cta(
                    loading: state.isLoading,
                    disabled: !_notification || !_edit || !_urgent,
                    onPressed:
                        !(_notification && _edit && _urgent) ? null : _publish,
                    child: Text(context.t.notice.write.consent.upload),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
