import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
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
                  onPressed: () =>
                      NoticeEditBodyRoute(showEnglish: false).push(context),
                ),
                const SizedBox(height: 10),
                _ActionButton(
                  disabled: !state.isLoaded,
                  icon: Assets.icons.language,
                  title: context.t.notice.edit.addEnglish,
                  onPressed: () =>
                      NoticeEditBodyRoute(showEnglish: true).push(context),
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
