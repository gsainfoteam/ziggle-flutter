import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Title(),
        _ImageAction(),
        _Content(),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Assets.icons.profileCircle.image(height: 24),
              const SizedBox(width: 8),
              const Text(
                '양태규',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 5),
              const Text(
                '·',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Palette.text300,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                t.notice.calendar.minutesAgo(minutes: 32),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Palette.text300,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Palette.primary100,
                ),
                child: Text.rich(
                  t.notice.dday.daysLeft(
                    n: 12,
                    nBuilder: (n) => TextSpan(
                      text: n.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  style: const TextStyle(color: Palette.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '2024학년도 신규 집행국원을 모집합니다! 레게노 2024학년도 신규 집행국원을 모집합니다! 레게노 2024학년도 신규 집행국원을 모집합니다! 제목 이렇게 겁나길게쓰면 안이뻐지긴하네',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

class _ImageAction extends StatefulWidget {
  const _ImageAction();

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
        AspectRatio(
          aspectRatio: 1,
          child: PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) => const Placeholder(),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              color: Colors.red,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Assets.icons.fireFlame.image(
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                  padding: EdgeInsets.zero,
                ),
                const Text('67', style: TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Assets.icons.shareAndroid.image(),
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Assets.icons.bell.image(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    const content =
        "보세 옷을 걸쳐도 브랜드 묻는 DM이 와 I'm too sexy 헌 집 주고 새집 프리미엄이 붙어 두 배 세 배 네 배 yeah 나는 새삥 모든 게 다 새삥 보세 옷을 걸쳐도 브랜드 묻는 DM이 와 I'm too sexy 헌 집 주고 새집 프리미엄이 붙어 두 배 세 배 네 배 yeah 나는 새삥 모든 게 다 새삥";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultTextStyle(
            style: const TextStyle(color: Palette.primary100),
            child: Wrap(
              spacing: 4,
              children: ['모집', '집행위원회'].map((e) => Text('#$e')).toList(),
            ),
          ),
          _isExpanded
              ? const Text(content)
              : InkWell(
                  onTap: () => setState(() => _isExpanded = true),
                  child: ExtendedText(
                    content,
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
