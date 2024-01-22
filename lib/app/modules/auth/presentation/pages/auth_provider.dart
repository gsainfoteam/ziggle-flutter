import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';

import '../bloc/auth_bloc.dart';

class AuthProvider extends StatelessWidget {
  const AuthProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => sl<AuthBloc>()..add(const AuthEvent.load()),
      child: child,
    );
  }
}
