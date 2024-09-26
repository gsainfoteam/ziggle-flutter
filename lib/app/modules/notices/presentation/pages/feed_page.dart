import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_list_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/list_layout.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.grayLight,
      appBar: ZiggleAppBar.main(
        onTapSearch: () => const SearchRoute().push(context),
        onTapWrite: () {
          if (UserBloc.userOrNull(context) == null) {
            return context.showToast(
              context.t.user.login.description,
            );
          }
          const NoticeWriteBodyRoute().push(context);
        },
      ),
      body: BlocProvider(
        create: (_) => sl<NoticeListBloc>()
          ..add(const NoticeListEvent.load(NoticeType.all)),
        child: const ListLayout(),
      ),
    );
  }
}
