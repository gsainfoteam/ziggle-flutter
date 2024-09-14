import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/d_day.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({
    super.key,
    required this.notice,
    required this.onPressed,
    required this.onLike,
    required this.onShare,
  });

  final NoticeEntity notice;
  final VoidCallback onPressed;
  final VoidCallback onLike;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return ZigglePressable(
      onPressed: onPressed,
      decoration: const BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
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
                          Text(
                            notice.author.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Palette.black,
                              height: 1,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                          const SizedBox(width: 5),
                          if (notice.isCertified)
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
                if (notice.deadline != null) DDay(deadline: notice.deadline!),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              notice.title,
              style: const TextStyle(
                color: Palette.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (notice.imageUrls.isNotEmpty)
              Image.network(
                notice.imageUrls.first,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              ExtendedText(
                notice.content,
                maxLines: 4,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Palette.black,
                ),
                overflowWidget: TextOverflowWidget(
                  child: Text.rich(
                    t.notice.viewMore(
                      more: (more) => TextSpan(
                        text: more,
                        style: const TextStyle(color: Palette.grayText),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                ZigglePressable(
                  behavior: HitTestBehavior.translucent,
                  onPressed: onLike,
                  child: Row(
                    children: [
                      Assets.icons.fire.svg(width: 30),
                      const SizedBox(width: 5),
                      Text(
                        '${notice.likes}',
                        style: const TextStyle(
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
                  behavior: HitTestBehavior.translucent,
                  onPressed: onShare,
                  child: Assets.icons.share.svg(width: 30),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
