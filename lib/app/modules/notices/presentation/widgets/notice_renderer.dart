import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/confirm.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/groups/presentation/widgets/sliver_pinned_box_adapter.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_content_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_reaction.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/cubit/copy_link_cubit.dart';
import 'package:ziggle/app/modules/notices/presentation/cubit/share_cubit.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/notice_body.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/tag.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeRenderer extends StatefulWidget {
  const NoticeRenderer({
    super.key,
    required this.notice,
    this.hideAuthorSetting = false,
  });

  final NoticeEntity notice;
  final bool hideAuthorSetting;

  @override
  State<NoticeRenderer> createState() => _NoticeRendererState();
}

class _NoticeRendererState extends State<NoticeRenderer> {
  final _controller = ScrollController();
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollHandler);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_scrollHandler)
      ..dispose();
    super.dispose();
  }

  void _scrollHandler() {
    setState(() {
      _scrolled = _controller.offset > 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _controller,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        const SliverToBoxAdapter(child: SizedBox(height: 9)),
        if (widget.notice.currentDeadline != null)
          SliverPinnedBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: _scrolled
                        ? BorderRadius.circular(30)
                        : BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 18,
                        ),
                        decoration: ShapeDecoration(
                          color: _scrolled
                              ? Palette.white.withValues(alpha: 0.8)
                              : widget.notice.currentDeadline!
                                      .isBefore(DateTime.now())
                                  ? Palette.grayText
                                  : Palette.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: _scrolled
                                ? BorderRadius.circular(30)
                                : BorderRadius.circular(10),
                            side: BorderSide(color: Color(0xFFEFEFEF)),
                          ),
                        ),
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeOut,
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 100),
                            style: DefaultTextStyle.of(context)
                                .style
                                .merge(TextStyle(
                                  color: _scrolled
                                      ? widget.notice.currentDeadline!
                                              .isBefore(DateTime.now())
                                          ? Palette.grayText
                                          : Palette.primary
                                      : Palette.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: _scrolled
                                  ? MainAxisSize.min
                                  : MainAxisSize.max,
                              children: [
                                Text(
                                  context.t.notice.detail.deadline,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  DateFormat.yMd().add_Hm().format(
                                      widget.notice.currentDeadline!.toLocal()),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            sliver: SliverToBoxAdapter(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Assets.images.defaultProfile.image(width: 48),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.notice.author.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Palette.black,
                        ),
                      ),
                      Text(
                        DateFormat.yMd()
                            .add_Hm()
                            .format(widget.notice.createdAt),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Palette.grayText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (!widget.hideAuthorSetting &&
              UserBloc.userOrNull(context)?.uuid == widget.notice.author.uuid)
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              sliver: SliverToBoxAdapter(child: _buildAuthorSetting()),
            ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            sliver: SliverToBoxAdapter(
              child: Text(
                widget.notice.titles.current,
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
                  Tag(tag: widget.notice.category.name),
                  ...widget.notice.tags.map((tag) => Tag(tag: tag)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            sliver: SliverList.separated(
              itemCount: widget.notice.images.length,
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
                    image: widget.notice.images[index],
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
              child: NoticeBody(body: widget.notice.contents.current),
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
                      onPressed: () {
                        AnalyticsRepository.click(AnalyticsEvent.noticeReaction(
                            widget.notice.id, reaction, PageSource.detail));
                        if (UserBloc.userOrNull(context) == null) {
                          return context.showToast(
                            context.t.user.login.description,
                          );
                        }
                        context.read<NoticeBloc>().add(
                              widget.notice.reacted(reaction)
                                  ? NoticeEvent.removeReaction(reaction)
                                  : NoticeEvent.addReaction(reaction),
                            );
                      },
                      isSelected: widget.notice.reacted(reaction),
                      icon: reaction.icon(widget.notice.reacted(reaction)),
                      text: widget.notice.reactionsBy(reaction).toString(),
                    ),
                  ),
                  _ChipButton(
                    onPressed: () {
                      AnalyticsRepository.click(AnalyticsEvent.noticeShare(
                          widget.notice.id, PageSource.detail));
                      context.read<ShareCubit>().share(widget.notice);
                    },
                    icon: Assets.icons.share.svg(),
                    text: context.t.notice.detail.share,
                  ),
                  _ChipButton(
                    onPressed: () async {
                      AnalyticsRepository.click(
                          AnalyticsEvent.noticeCopy(widget.notice.id));
                      final result = await context
                          .read<CopyLinkCubit>()
                          .copyLink(widget.notice);
                      if (!result || !context.mounted) return;
                      context.showToast(context.t.notice.detail.copied);
                    },
                    icon: Assets.icons.link.svg(),
                    text: context.t.notice.detail.copy,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            sliver: SliverList.separated(
              itemBuilder: (context, index) {
                final previousDeadline = index == 0
                    ? widget.notice.deadline
                    : widget.notice.additionalContents.locales
                        .elementAt(index - 1)
                        .deadline;
                final additional =
                    widget.notice.additionalContents.locales.elementAt(index);
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Palette.grayLight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            context.t.notice.additional.title,
                            style: const TextStyle(
                              height: 1,
                              fontSize: 20,
                              color: Palette.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat.yMd()
                                .add_Hm()
                                .format(additional.createdAt.toLocal()),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Palette.grayText,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (additional.deadline != null &&
                          additional.deadline != previousDeadline) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 13),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            border: Border.fromBorderSide(
                              BorderSide(color: Palette.primary),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                context.t.notice.additional.deadline,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Palette.primary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    DateFormat.yMd()
                                        .add_Hm()
                                        .format(previousDeadline!.toLocal()),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Palette.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Assets.icons.nextArrow
                                      .svg(width: 20, height: 20),
                                ],
                              ),
                              Text(
                                DateFormat.yMd()
                                    .add_Hm()
                                    .format(additional.deadline!.toLocal()),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Palette.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      Text(
                        widget.notice.additionalContents[index].content,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Palette.grayText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemCount: widget.notice.additionalContents.locales.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 9)),
        ],
      ),
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
              onPressed: () {
                AnalyticsRepository.click(
                    AnalyticsEvent.noticeEdit(widget.notice.id));
                const NoticeEditRoute().push(context);
              },
              icon: Assets.icons.editPencil,
              text: context.t.notice.settings.edit.action,
            ),
            _AuthorSettingAction(
              onPressed: () async {
                AnalyticsRepository.click(
                    AnalyticsEvent.noticeDelete(widget.notice.id));
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
            if (!widget.notice.isPublished)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AuthorSettingAction(
                    onPressed: () async {
                      AnalyticsRepository.click(
                          AnalyticsEvent.noticeSendNotification(
                              widget.notice.id));
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
