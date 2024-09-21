import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/confirm.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_reaction.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/created_at.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/notice_body.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/tag.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeRenderer extends StatelessWidget {
  const NoticeRenderer({
    super.key,
    required this.notice,
    this.hideAuthorSetting = false,
  });

  final NoticeEntity notice;
  final bool hideAuthorSetting;

  @override
  Widget build(BuildContext context) {
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
        if (!hideAuthorSetting &&
            UserBloc.userOrNull(context)?.uuid == notice.author.uuid)
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            sliver: SliverToBoxAdapter(child: _buildAuthorSetting()),
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
            itemCount: notice.images.length,
            itemBuilder: (context, index) => Container(
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Palette.grayBorder),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image(
                  image: notice.images[index],
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
                    onPressed: () => context.read<NoticeBloc>().add(
                          notice.reacted(reaction)
                              ? NoticeEvent.removeReaction(reaction)
                              : NoticeEvent.addReaction(reaction),
                        ),
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

  Container _buildAuthorSetting() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        color: Palette.grayLight,
        border: Border.symmetric(
          horizontal: BorderSide(color: Palette.grayBorder),
        ),
      ),
      child: Builder(
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AuthorSettingAction(
              onPressed: () => NoticeEditRoute(notice: notice).push(context),
              icon: Assets.icons.editPencil,
              text: context.t.notice.settings.edit.action,
            ),
            _AuthorSettingAction(
              onPressed: () async {
                final result = await context.showDialog<bool>(
                  title: context.t.notice.settings.delete.title,
                  content: context.t.notice.settings.delete.description,
                  onConfirm: (context) => Navigator.pop(context, true),
                );
                if (result != true || !context.mounted) return;
                final bloc = context.read<NoticeBloc>();
                final blocker = bloc.stream.firstWhere((s) => s.isDeleted);
                bloc.add(const NoticeEvent.delete());
                await blocker;
                if (!context.mounted) return;
                context.maybePop();
              },
              icon: Assets.icons.delete,
              text: context.t.notice.settings.delete.action,
            ),
            if (notice.publishedAt == null)
              Column(
                children: [
                  _AuthorSettingAction(
                    onPressed: () async {
                      final result = await context.showDialog<bool>(
                        title: context.t.notice.settings.sendNotification.title,
                        content: context
                            .t.notice.settings.sendNotification.description,
                        onConfirm: (context) => Navigator.pop(context, true),
                      );
                      if (result != true || !context.mounted) return;
                      final bloc = context.read<NoticeBloc>();
                      final blocker = bloc.stream.firstWhere((s) => s.isLoaded);
                      bloc.add(const NoticeEvent.sendNotification());
                      await blocker;
                    },
                    icon: Assets.icons.bell,
                    text: context.t.notice.settings.sendNotification.action,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 9),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                          BorderSide(color: Palette.primary),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Assets.icons.warningTriangle.svg(width: 14),
                          const SizedBox(width: 5),
                          Text(
                            context.t.notice.settings.sendNotification.caution,
                            style: const TextStyle(
                              color: Palette.primary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _AuthorSettingAction extends StatelessWidget {
  const _AuthorSettingAction({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final SvgGenImage icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ZigglePressable(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        child: Row(
          children: [
            icon.svg(width: 20),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                color: Palette.grayText,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
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
