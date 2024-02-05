import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_content_entity.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/enums/notice_reaction.dart';
import '../../domain/enums/notice_type.dart';
import 'created_at.dart';
import 'd_day.dart';
import 'scrolling_page_indicator.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({
    super.key,
    required this.notice,
    this.onTapDetail,
  });

  final NoticeEntity notice;
  final VoidCallback? onTapDetail;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapDetail,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            _Title(
              title: notice.contents.main.title,
              author: notice.author,
              createdAt: notice.createdAt,
              deadline: notice.currentDeadline,
            ),
            _ImageAction(
              imagesUrl: notice.imagesUrl,
              likes: notice.reactions
                  .where((e) => e.emoji == NoticeReaction.like.emoji)
                  .length,
            ),
            _Content(
              tags: notice.tags
                  .map((e) => e['name'] as String)
                  .map((e) => NoticeType.fromTag(e)?.label ?? e)
                  .toList(),
              content: notice.contents.main.body,
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.title,
    required this.author,
    required this.createdAt,
    required this.deadline,
  });

  final String title;
  final String author;
  final DateTime createdAt;
  final DateTime? deadline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Assets.icons.profileCircle.svg(height: 24),
              const SizedBox(width: 8),
              Text(author, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(width: 5),
              const Text(
                '·',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Palette.text300,
                ),
              ),
              const SizedBox(width: 5),
              CreatedAt(createdAt: createdAt),
              const Spacer(),
              if (deadline != null) DDay(deadline: deadline!),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

class _ImageAction extends StatefulWidget {
  const _ImageAction({required this.imagesUrl, required this.likes});

  final List<String> imagesUrl;
  final int likes;

  @override
  State<_ImageAction> createState() => _ImageActionState();
}

class _ImageActionState extends State<_ImageAction> {
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.imagesUrl.isNotEmpty)
          AspectRatio(
            aspectRatio: 1,
            child: PageView.builder(
              itemCount: widget.imagesUrl.length,
              controller: _pageController,
              itemBuilder: (context, index) => Image.network(
                widget.imagesUrl[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
        Stack(
          alignment: Alignment.center,
          children: [
            if (widget.imagesUrl.isNotEmpty)
              ScrollingPageIndicator(
                itemCount: widget.imagesUrl.length,
                controller: _pageController,
                dotColor: Palette.textGrey,
                dotSelectedColor: Palette.primary100,
              ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Assets.icons.fireFlame.svg(
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                  padding: EdgeInsets.zero,
                ),
                Text(
                  '${widget.likes}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Assets.icons.shareAndroid.svg(),
                  padding: EdgeInsets.zero,
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  constraints:
                      const BoxConstraints.tightFor(width: 48, height: 48),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Assets.icons.bell.svg(),
                  padding: EdgeInsets.zero,
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  constraints:
                      const BoxConstraints.tightFor(width: 48, height: 48),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({required this.tags, required this.content});

  final List<String> tags;
  final String content;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultTextStyle.merge(
            style: const TextStyle(color: Palette.primary100),
            child: Wrap(
              spacing: 4,
              children: widget.tags.map((e) => Text('#$e')).toList(),
            ),
          ),
          _isExpanded
              ? Text(widget.content)
              : InkWell(
                  onTap: () => setState(() => _isExpanded = true),
                  child: ExtendedText(
                    widget.content,
                    maxLines: 2,
                    overflowWidget: TextOverflowWidget(
                      child: Text.rich(
                        t.notice.viewMore(
                          more: (more) => TextSpan(
                            text: more,
                            style: const TextStyle(color: Palette.textGrey),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
