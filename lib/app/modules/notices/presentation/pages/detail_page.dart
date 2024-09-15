import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_reaction.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/created_at.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/notice_body.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/tag.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.notice});
  final NoticeEntity notice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: context.t.notice.detail.back,
        title: Text(context.t.notice.detail.title),
      ),
      body: BlocProvider(
        create: (_) => sl<NoticeBloc>()..add(NoticeEvent.load(notice)),
        child: const _Layout(),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    final notice = context.select((NoticeBloc bloc) => bloc.state.entity);
    if (notice == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 9)),
        if (notice.deadline != null)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 18,
                ),
                decoration: ShapeDecoration(
                  color: notice.deadline!.isBefore(DateTime.now())
                      ? Palette.grayText
                      : Palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.t.notice.detail.deadline,
                      style: const TextStyle(
                        color: Palette.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat.yMd().add_Hm().format(notice.deadline!),
                      style: const TextStyle(
                        color: Palette.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          sliver: SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.images.defaultProfile.image(width: 36),
                const SizedBox(width: 8),
                Text(
                  notice.author.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Palette.black,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  '·',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Palette.grayText,
                  ),
                ),
                const SizedBox(width: 5),
                CreatedAt(createdAt: notice.createdAt),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          sliver: SliverToBoxAdapter(
            child: Text(
              notice.title,
              style: const TextStyle(
                color: Palette.black,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          sliver: SliverToBoxAdapter(
            child: Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                Tag(tag: notice.category.name),
                ...notice.tags.map((tag) => Tag(tag: tag)),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          sliver: SliverList.separated(
            itemCount: notice.imageUrls.length,
            itemBuilder: (context, index) => Container(
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Palette.grayBorder),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  notice.imageUrls[index],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 18),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          sliver: SliverToBoxAdapter(
            child: NoticeBody(body: notice.content),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          sliver: SliverToBoxAdapter(
            child: Wrap(
              spacing: 8,
              runSpacing: 10,
              children: [
                ...NoticeReaction.values.map(
                  (reaction) => _ChipButton(
                    onPressed: () {},
                    isSelected: notice.reacted(reaction),
                    icon: reaction.icon(notice.reacted(reaction)),
                    text: notice.reactionsBy(reaction).toString(),
                  ),
                ),
                _ChipButton(
                  onPressed: () {},
                  icon: Assets.icons.share.svg(),
                  text: context.t.notice.detail.share,
                ),
                _ChipButton(
                  onPressed: () {},
                  icon: Assets.icons.link.svg(),
                  text: context.t.notice.detail.copy,
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 9)),
      ],
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({
    this.isSelected = false,
    required this.icon,
    required this.onPressed,
    required this.text,
  });

  final bool isSelected;
  final Widget icon;
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ZigglePressable(
      onPressed: onPressed,
      decoration: BoxDecoration(
        color: isSelected ? Palette.black : Palette.grayLight,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: icon,
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Palette.grayLight : Palette.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
