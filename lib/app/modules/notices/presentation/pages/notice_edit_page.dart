import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/edit_deadline.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class NoticeEditPage extends StatelessWidget {
  const NoticeEditPage({super.key});

  void _publish() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: context.t.common.cancel,
        title: Text(context.t.notice.edit.title),
        actions: [
          ZiggleButton.text(
            disabled: false,
            onPressed: _publish,
            child: Text(context.t.notice.write.publish),
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
                const EditDeadline(
                    duration: Duration(minutes: 13, seconds: 39)),
                const SizedBox(height: 25),
                _ActionButton(
                  disabled: !state.isLoaded,
                  icon: Assets.icons.body,
                  title: context.t.notice.edit.editBody,
                  onPressed: () => const NoticeEditBodyRoute().push(context),
                ),
                const SizedBox(height: 10),
                _ActionButton(
                  disabled: !state.isLoaded,
                  icon: Assets.icons.language,
                  title: context.t.notice.edit.addEnglish,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                _ActionButton(
                  disabled: false,
                  icon: Assets.icons.add,
                  title: context.t.notice.edit.additional.action,
                  onPressed: () {},
                ),
                const SizedBox(height: 25),
                ZiggleButton.cta(
                  emphasize: false,
                  onPressed: () {},
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
      decoration: BoxDecoration(
        color: disabled ? Palette.gray : Palette.grayLight,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
            icon.svg(height: 40, width: 40),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Palette.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
