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
          const SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text('최신')),
                    Chip(label: Text('최신')),
                    Chip(label: Text('최신')),
                    Chip(label: Text('최신')),
                    Chip(label: Text('최신')),
                    Chip(label: Text('최신')),
                    Chip(label: Text('최신')),
                    Chip(label: Text('최신')),
                    Chip(label: Text('최신')),
                    Chip(label: Text('최신')),
                    Chip(label: Text('최신')),
                    Chip(label: Text('최신')),
                    Chip(label: Text('최신')),
                    Chip(label: Text('최신')),
                    Chip(label: Text('최신')),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
