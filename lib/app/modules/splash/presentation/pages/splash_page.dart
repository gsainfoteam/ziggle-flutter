import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

/// 앱을 켤 때 로그인 상태와 프로필을 확인하는 동안 보여 주는 화면.
///
/// 화면만 그린다. 다음 화면으로 넘기는 일은 `AppRouter`의 가드가 한다.
@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: Center(child: Assets.logo.transparent.image()),
    );
  }
}
