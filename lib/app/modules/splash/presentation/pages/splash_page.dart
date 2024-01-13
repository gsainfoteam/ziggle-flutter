import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/splash/presentation/bloc/splash_bloc.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SplashBloc>()..add(const SplashEvent.init()),
      child: BlocConsumer<SplashBloc, SplashState>(
        listenWhen: (_, c) => c.mapOrNull(loaded: (_) => true) ?? false,
        listener: (context, state) => context.go(Paths.feed),
        builder: (context, state) => state.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          error: (message) => Scaffold(
            backgroundColor: Palette.primary100,
            body: Center(
              child: Text('Error: $message'),
            ),
          ),
        ),
      ),
    );
  }
}
