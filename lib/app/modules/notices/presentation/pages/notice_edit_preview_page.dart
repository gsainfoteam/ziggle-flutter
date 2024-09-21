import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_back_button.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_write_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/notice_renderer.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class NoticeEditPreviewPage extends StatelessWidget {
  const NoticeEditPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar(
        leading: ZiggleBackButton(label: context.t.notice.write.configTitle),
        title: Text(context.t.notice.write.preview),
      ),
      body: Builder(
        builder: (context) {
          final draft =
              context.select((NoticeWriteBloc bloc) => bloc.state.draft);
          final notice =
              context.select((NoticeBloc bloc) => bloc.state.entity!);
          return NoticeRenderer(
            notice: notice.addDraft(draft),
            hideAuthorSetting: true,
          );
        },
      ),
    );
  }
}
