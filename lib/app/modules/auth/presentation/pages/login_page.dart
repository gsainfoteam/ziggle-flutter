import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/auth/presentation/bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _login(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEvent.login());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            const Text('Login Page'),
            const Spacer(),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) => ElevatedButton(
                onPressed: state.isLoading ? null : () => _login(context),
                child: const Text('Login'),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
