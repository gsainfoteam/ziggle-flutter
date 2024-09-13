import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_chip.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Assets.images.defaultProfile.image(width: 40),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '홍길동',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Palette.black,
                            height: 1,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Assets.icons.certificatedBadge.svg(width: 20),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '10분 전',
                      style: TextStyle(
                        fontSize: 12,
                        color: Palette.gray,
                      ),
                    ),
                  ],
                ),
              ),
              const ZiggleChip(label: '343days left'),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '공지 제목',
            style: TextStyle(
              color: Palette.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          if (true)
            Image.network(
              'https://picsum.photos/200/300',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          else
            const Text(
              '공지 내용',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Palette.black,
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              ZigglePressable(
                onPressed: () {},
                child: Row(
                  children: [
                    Assets.icons.fire.svg(width: 30),
                    const SizedBox(width: 5),
                    const Text(
                      '10',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Palette.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ZigglePressable(
                onPressed: () {},
                child: Assets.icons.share.svg(width: 30),
              ),
            ],
          )
        ],
      ),
    );
  }
}
