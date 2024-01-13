import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/notice_card.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryPadding = MediaQuery.paddingOf(context);
    final toolbarHeight = Theme.of(context).appBarTheme.toolbarHeight!;
    final bottomHeight = toolbarHeight + 8;
    return Scaffold(
      body: RefreshIndicator(
        edgeOffset: mediaQueryPadding.top + toolbarHeight + bottomHeight,
        onRefresh: () {
          HapticFeedback.mediumImpact();
          return Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: toolbarHeight,
              floating: true,
              leading: Center(
                child: Assets.logo.black.image(height: toolbarHeight),
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
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(bottomHeight),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Wrap(
                      spacing: 8,
                      children: NoticeType.sections
                          .map(
                            (e) => ActionChip.elevated(
                              labelPadding: const EdgeInsets.only(right: 8),
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
              ),
            ),
            SliverList.separated(
              itemBuilder: (context, index) => const NoticeCard(),
              separatorBuilder: (context, index) => const Divider(),
            ),
          ],
        ),
      ),
    );
  }
}
