import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_create_bloc.dart';

@RoutePage()
class GroupCreationShellLayout extends StatelessWidget {
  const GroupCreationShellLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GroupCreateBloc>(),
      child: const AutoRouter(),
    );
  }
}
