import 'package:flutter/material.dart';
import 'package:ziggle/gen/assets.gen.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            leading: Center(
              child: Assets.logo.black.image(height: 48),
            ),
            actions: [
              IconButton(
                icon: Assets.icons.search.image(),
                onPressed: () {},
              ),
              IconButton(
                icon: Assets.icons.bell.image(),
                onPressed: () {},
              ),
              IconButton(
                icon: Assets.icons.user.image(),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
