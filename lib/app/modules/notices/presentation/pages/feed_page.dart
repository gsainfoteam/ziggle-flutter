import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: Theme.of(context).appBarTheme.toolbarHeight!,
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
                icon: Assets.icons.editPencil.image(),
                onPressed: () {},
              ),
              IconButton(
                icon: Assets.icons.user.image(),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Wrap(
                  spacing: 8,
                  children: NoticeType.sections
                      .map(
                        (e) => ActionChip.elevated(
                          avatar: e.icon.image(
                            width: 16,
                            color: e == NoticeType.all
                                ? Palette.background100
                                : null,
                          ),
                          label: Text(t.notice.type(type: e)),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                          },
                          labelStyle: TextStyle(
                            color: e == NoticeType.all
                                ? Palette.background100
                                : null,
                          ),
                          backgroundColor:
                              e == NoticeType.all ? Palette.text100 : null,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
