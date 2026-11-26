import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/utils/cover_resize_image.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_reaction.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/created_at.dart';
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

  static const _imageHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    // E2E 테스트가 카드와 버튼을 공지 ID로 찾는다. 읽기 이름은 바꾸지 않는다.
    return Semantics(
      identifier: 'notice.card.${notice.id}',
      child: ZigglePressable(
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
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            const SizedBox(width: 5),
                            if (notice.isCertified)
                              Assets.icons.certificatedBadge.svg(width: 20),
                          ],
                        ),
                        const SizedBox(height: 2),
                        CreatedAt(
                          createdAt: notice.createdAt,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Palette.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (notice.currentDeadline != null)
                    DDay(deadline: notice.currentDeadline!),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notice.titles.current,
                style: const TextStyle(
                  color: Palette.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (notice.images.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // 원본 해상도로 디코딩하면 관성 스크롤 중 새 카드가 나타날
                      // 때마다 큰 디코딩과 업로드가 일어나므로, 카드에 보이는
                      // 크기만큼만 디코딩한다. 상세 화면은 원본을 그대로 쓴다.
                      final ratio = MediaQuery.devicePixelRatioOf(context);
                      return Image(
                        image: CoverResizeImage(
                          notice.images.first,
                          width: (constraints.maxWidth * ratio).ceil(),
                          height: (_imageHeight * ratio).ceil(),
                        ),
                        height: _imageHeight,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                )
              else
                ExtendedText(
                  notice.contents.current,
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
                  Semantics(
                    identifier: 'notice.card.${notice.id}.like',
                    selected: notice.reacted(NoticeReaction.like),
                    child: ZigglePressable(
                      behavior: HitTestBehavior.translucent,
                      onPressed: onLike,
                      child: Row(
                        children: [
                          if (notice.reacted(NoticeReaction.like))
                            Assets.icons.fireActivate.svg(width: 30)
                          else
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
                  ),
                  const Spacer(),
                  Semantics(
                    identifier: 'notice.card.${notice.id}.share',
                    child: ZigglePressable(
                      behavior: HitTestBehavior.translucent,
                      onPressed: onShare,
                      child: Assets.icons.share.svg(width: 30),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
