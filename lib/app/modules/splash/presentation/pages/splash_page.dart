import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/core/presentation/bloc/link_bloc.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key, this.delay = false});

  final bool delay;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        widget.delay ? const Duration(seconds: 1) : Duration.zero,
        () {
          if (!mounted) return;
          final linkData =
              context.read<LinkBloc>().state.whenOrNull(loaded: (link) => link);
          if (linkData != null) {
            try {
              context.router
                ..replaceAll([const FeedRoute()])
                ..replaceNamed(linkData);
              return;
            } catch (_) {}
          }
          context.router.replaceAll([const FeedRoute()]);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: Center(
        child: Assets.logo.transparent.image(),
      ),
    );
  }
}
