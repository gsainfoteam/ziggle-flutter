import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class NoticeWriteConsentPage extends StatelessWidget {
  const NoticeWriteConsentPage({super.key});

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
                const SizedBox(height: 10),
                const SizedBox(height: 24),
                ZiggleButton.cta(
                  onPressed: () {
                    context.router
                        .popUntilRouteWithName(NoticeWriteBodyRoute.name);
                    // TODO: change to notice detail page
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
