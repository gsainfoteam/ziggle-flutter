import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/gen/assets.gen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: Assets.logo.icon
            .image(alignment: Alignment.centerLeft)
            .paddingSymmetric(
              horizontal: 15,
              vertical: 10,
            ),
      ),
    );
  }
}
