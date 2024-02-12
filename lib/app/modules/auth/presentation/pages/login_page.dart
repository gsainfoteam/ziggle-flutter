import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/core/domain/repositories/api_channel_repository.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/app/values/strings.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../bloc/auth_bloc.dart';

bool _isValidPassword(String password) {
  final bytes = utf8.encode(password);
  final digest = sha1.convert(bytes).toString();
  return digest == 'bf782aa0b57c80e2b10b2f195327a32f60e250af';
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Layout();
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _BoardAnimation(openHidden: () async {
            final text = TextEditingController();
            await showCupertinoDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => CupertinoAlertDialog(
                title: const Text('enter password'),
                content: CupertinoTextField(controller: text),
              ),
            );
            text.dispose();
            if (!_isValidPassword(text.text)) return;
            final channel = sl<ApiChannelRepository>().toggleChannel();
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('current using ${channel.baseUrl}'),
                duration: const Duration(seconds: 2),
              ),
            );
          })),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Column(
                    children: [
                      Assets.logo.black.image(height: 100),
                      Text.rich(
                        t.setting.promotion(
                          red: (text) => TextSpan(
                            text: text,
                            style: const TextStyle(color: Palette.primary100),
                          ),
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) => ZiggleButton(
                        text: t.setting.login,
                        onTap: () => context
                            .read<AuthBloc>()
                            .add(const AuthEvent.login()),
                        loading: state.maybeWhen(
                          orElse: () => false,
                          loading: () => true,
                        ),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ZiggleButton(
                    text: t.setting.withoutLogin,
                    color: Colors.transparent,
                    onTap: () => const FeedRoute().go(context),
                    textStyle: const TextStyle(
                      color: Palette.textGrey,
                      decoration: TextDecoration.underline,
                      decorationColor: Palette.textGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    t.setting.consent(
                      terms: (text) => TextSpan(
                          text: text,
                          style: const TextStyle(color: Palette.primary100),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                launchUrlString(Strings.termsOfServiceUrl)),
                    ),
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardAnimation extends StatelessWidget {
  final VoidCallback? openHidden;
  const _BoardAnimation({this.openHidden});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          _BoardAnimationLayout(constraints, openHidden),
    );
  }
}

class _BoardAnimationLayout extends StatefulWidget {
  final BoxConstraints constraints;
  final VoidCallback? openHidden;

  const _BoardAnimationLayout(this.constraints, this.openHidden);

  @override
  State<_BoardAnimationLayout> createState() => _BoardAnimationLayoutState();
}

class _BoardAnimationLayoutState extends State<_BoardAnimationLayout> {
  static const _kGap = 12.0;
  static const _kWidth = 160.0;

  late final Timer _timer;
  final _rects = <Rect>[];
  var speed = 10.0;
  final _clicks = <double>[];

  @override
  void initState() {
    super.initState();
    _period();
    _timer = Timer.periodic(const Duration(milliseconds: 10), _period);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _period([_]) {
    setState(() {
      final maxHeight = widget.constraints.maxHeight;
      final maxWidth = widget.constraints.maxWidth;

      while (_rects.isEmpty || _rects.last.left > 0) {
        final lastLeft = _rects.isEmpty ? 0 : _rects.last.left;
        final left = lastLeft - _kWidth - _kGap;
        final right = left + _kWidth;

        final rects = <Rect>[];
        while (rects.isEmpty || rects.last.bottom < maxHeight) {
          final lastBottom = rects.isEmpty ? -30.0 : rects.last.bottom;
          final top = lastBottom + _kGap;
          final bottom = top + Random().nextDouble() * 100 + 100;
          rects.add(
            Rect.fromLTRB(
              left,
              lastBottom + _kGap,
              right,
              bottom,
            ),
          );
        }
        rects.removeLast();
        _rects.addAll(rects);
      }

      if (_rects.first.right < maxWidth) {
        speed /= 0.95;
      } else if (speed > 0.2) {
        speed *= 0.95;
      }
      _rects.removeWhere((rect) => rect.left > maxWidth + _kWidth);
      for (var i = 0; i < _rects.length; i++) {
        final rect = _rects[i];
        _rects[i] = rect.translate(speed, 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _rects
          .map((rect) => _Article(
                rect: rect,
                onTap: _checkHidden,
              ))
          .toList(),
    );
  }

  void _checkHidden(opacity) {
    _clicks.add(opacity);
    final zip = IterableZip([
      _clicks.reversed.take(2),
      _clicks.reversed.skip(1).take(2),
    ]);
    final opacityCondition =
        zip.every((element) => element.first - element.last > 0.1);
    final countCondition = zip.length == 2;
    if (!opacityCondition || !countCondition) return;
    widget.openHidden?.call();
  }
}

class _Article extends StatelessWidget {
  final Rect rect;
  final void Function(double opacity)? onTap;

  const _Article({required this.rect, this.onTap});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final opacity = max(0.0, min((rect.left / width) / 2.5 + 0.5, 1.0));
    return Positioned.fromRect(
      rect: rect,
      child: ZiggleButton(
        onTap: () => onTap?.call(opacity),
        padding: EdgeInsets.zero,
        color: Palette.primary100.withOpacity(opacity),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
