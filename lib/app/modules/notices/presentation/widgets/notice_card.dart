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
      child: Row(
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
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
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

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
