import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:ziggle/app/modules/auth/presentation/pages/login_page.dart';

class AuthRequiredPage extends StatelessWidget {
  const AuthRequiredPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => state.maybeMap(
        authenticated: (_) => child,
        orElse: () => const LoginPage(),
      ),
    );
  }
}
