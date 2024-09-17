import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_write_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/consent_item.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class NoticeWriteConsentPage extends StatefulWidget {
  const NoticeWriteConsentPage({super.key});

  @override
  State<NoticeWriteConsentPage> createState() => _NoticeWriteConsentPageState();
}

class _NoticeWriteConsentPageState extends State<NoticeWriteConsentPage> {
  bool _notification = false;
  bool _edit = false;
  bool _urgent = false;

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
                ZiggleButton.cta(
                  disabled: !_notification || !_edit || !_urgent,
                  onPressed: !(_notification && _edit && _urgent)
                      ? null
                      : () async {
                          context.router
                              .popUntilRouteWithName(NoticeWriteBodyRoute.name);
                          final bloc = context.read<NoticeWriteBloc>();
                          context.replaceRoute(
                            DetailRoute(notice: NoticeEntity.fromId(1)),
                          );
                        },
                  child: Text(context.t.notice.write.consent.upload),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
