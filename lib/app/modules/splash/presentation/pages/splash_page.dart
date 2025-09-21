import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/core/presentation/bloc/link_bloc.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/auth_bloc.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authBloc = context.read<AuthBloc>();
      await Future.wait([
        Future.delayed(const Duration(seconds: 1)),
        authBloc.stream.firstWhere((s) => !s.isLoading),
      ]);
      if (!mounted) return;
      final linkData = context.read<LinkBloc>().state.whenOrNull(
        loaded: (link) => link,
      );
      final router = context.router;
      await router.replace(FeedRoute());
      if (linkData != null) {
        try {
          await router.pushPath(linkData);
        } catch (_) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: Center(child: Assets.logo.transparent.image()),
    );
  }
}
