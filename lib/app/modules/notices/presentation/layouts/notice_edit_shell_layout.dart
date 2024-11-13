import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_write_bloc.dart';

@RoutePage()
class NoticeEditShellLayout extends StatefulWidget {
  const NoticeEditShellLayout({super.key});

  @override
  State<NoticeEditShellLayout> createState() => _NoticeEditShellLayoutState();
}

class _NoticeEditShellLayoutState extends State<NoticeEditShellLayout> {
  @override
  void initState() {
    super.initState();
    context.read<NoticeBloc>().add(const NoticeEvent.getFull());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NoticeWriteBloc>(),
      child: BlocListener<NoticeBloc, NoticeState>(
        listener: (context, state) => state.mapOrNull(
          error: (error) => context.showToast(error.message),
        ),
        child: const AutoRouter(),
      ),
    );
  }
}
