import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_write_bloc.dart';

@RoutePage()
class NoticeWriteShellLayout extends StatelessWidget {
  const NoticeWriteShellLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NoticeWriteBloc>(),
      child: const AutoRouter(),
    );
  }
}
