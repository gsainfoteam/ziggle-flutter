import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/sliver_pinned_header.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_content_entity.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/enums/notice_reaction.dart';
import '../../domain/enums/notice_type.dart';
import '../../presentation/bloc/notice_bloc.dart';
import '../../presentation/widgets/additional_notice_content.dart';
import '../../presentation/widgets/notice_body.dart';
import '../cubit/share_cubit.dart';
import '../widgets/adaptive_dialog_action.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({super.key, required this.notice});

  final NoticeEntity notice;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<NoticeBloc>(param1: notice)..add(NoticeEvent.load(notice)),
        ),
        BlocProvider(create: (_) => sl<ShareCubit>()),
      ],
      child: const _Layout(),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.notice.title),
        leadingWidth: Theme.of(context).appBarTheme.toolbarHeight!,
        actions: [
          BlocBuilder<NoticeBloc, NoticeState>(
            builder: (context, state) {
              final notice = state.notice;
              if (AuthBloc.userOrNull(context)?.uuid != notice.author.uuid) {
                return const SizedBox.shrink();
              }
              return IconButton(
                onPressed: () => _AuthorSettingSheet.show(
                  context: context,
                  onEdit: notice.canEdit ? () {} : null,
                  onAdditional: () async {
                    final result = await WriteAdditionalRoute.fromEntity(notice)
                        .push(context);
                    if (result == null) return;
                    if (!context.mounted) return;
                    context.read<NoticeBloc>().add(NoticeEvent.load(result));
                  },
                  onEnglish: !notice.langs.contains(AppLocale.en)
                      ? () async {
                          final result =
                              await WriteForeignRoute.fromEntity(notice)
                                  .push<NoticeEntity>(context);
                          if (result == null) return;
                          if (!context.mounted) return;
                          context
                              .read<NoticeBloc>()
                              .add(NoticeEvent.load(result));
                        }
                      : null,
                  onDelete: () async {
                    final bloc = context.read<NoticeBloc>();
                    bloc.add(const NoticeEvent.delete());
                    await bloc.stream.firstWhere((state) => state.loaded);
                    if (!context.mounted) return;
                    context.pop();
                  },
                ),
                icon: Assets.icons.settings.svg(),
              );
            },
          ),
          BlocBuilder<NoticeBloc, NoticeState>(
            builder: (context, state) {
              final notice = state.notice;
              if (notice.currentDeadline == null) return const SizedBox();
              if (notice.currentDeadline!.toLocal().isBefore(DateTime.now())) {
                return const SizedBox();
              }
              return IconButton(
                onPressed: () {
                  if (AuthBloc.userOrNull(context) == null) {
                    const LoginRoute().push(context);
                    return;
                  }
                  context.read<NoticeBloc>().add(
                        notice.isReminded
                            ? const NoticeEvent.removeReminder()
                            : const NoticeEvent.addReminder(),
                      );
                },
                icon: BlocBuilder<NoticeBloc, NoticeState>(
                  builder: (context, state) => state.notice.isReminded
                      ? Assets.icons.bellActive.svg()
                      : Assets.icons.bell.svg(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final bloc = context.read<NoticeBloc>();
          bloc.add(const NoticeEvent.refresh());
          await bloc.stream.firstWhere((state) => state.loaded);
        },
        child: _buildScroll(context),
      ),
    );
  }

  Widget _buildScroll(BuildContext context) {
    final notice = context.select((NoticeBloc bloc) => bloc.state.notice);
    return CustomScrollView(
      slivers: [
        if (notice.currentDeadline != null)
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 10),
            sliver: SliverPinnedHeader(
              child: Container(
                color:
                    notice.currentDeadline!.toLocal().isBefore(DateTime.now())
                        ? Palette.textGreyDark
                        : Palette.primary100,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: DefaultTextStyle.merge(
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Palette.background100,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t.notice.deadline),
                      Text(
                        DateFormat.yMd()
                            .add_Hm()
                            .format(notice.currentDeadline!.toLocal()),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Assets.icons.profileCircle.svg(height: 24),
                    const SizedBox(width: 8),
                    Text(
                      notice.author.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
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
                      DateFormat.yMd()
                          .add_Hm()
                          .format(notice.createdAt.toLocal()),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Palette.text300,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notice.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                DefaultTextStyle.merge(
                  style: const TextStyle(color: Palette.primary100),
                  child: Wrap(
                    spacing: 4,
                    children: notice.tags
                        .map((e) => NoticeType.fromTag(e)?.label ?? e)
                        .map((e) => Text('#$e'))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList.builder(
          itemCount: notice.imageUrls.length,
          itemBuilder: (context, index) => Column(
            children: [
              const SizedBox(height: 10),
              Image.network(notice.imageUrls[index]),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (index == NoticeReaction.values.length) {
                    return _ChipButton(
                      onTap: () => context.read<ShareCubit>().share(notice),
                      selected: false,
                      child: Row(
                        children: [
                          Assets.icons.shareAndroid.svg(width: 20),
                          const SizedBox(width: 6),
                          Text(
                            t.notice.share,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  final reaction = NoticeReaction.values[index];
                  final userId = AuthBloc.userOrNull(context)?.uuid;
                  final selected = notice.reacted(reaction);
                  return _ReactionButton(
                    icon: reaction.icon(selected),
                    selected: selected,
                    count: notice.reactionsBy(reaction),
                    onTap: userId != null
                        ? () => context.read<NoticeBloc>().add(
                              selected
                                  ? NoticeEvent.removeReaction(reaction.emoji)
                                  : NoticeEvent.addReaction(reaction.emoji),
                            )
                        : () => const LoginRoute().push(context),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: NoticeReaction.values.length + 1,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          sliver: SliverToBoxAdapter(
            child: DefaultTextStyle.merge(
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Palette.textGreyDark,
              ),
              child: Text.rich(
                t.notice.views(
                  views: TextSpan(
                    text: notice.views.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          sliver: SliverToBoxAdapter(
            child: BlocBuilder<NoticeBloc, NoticeState>(
              builder: (context, state) => NoticeBody(body: notice.content),
            ),
          ),
        ),
        SliverList.builder(
          itemCount: notice.additionalContents.locales.length,
          itemBuilder: (context, index) {
            final previousDeadline = index == 0
                ? notice.deadline
                : notice.additionalContents.locales
                    .elementAt(index - 1)
                    .deadline;
            final additional =
                notice.additionalContents.locales.elementAt(index);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: AdditionalNoticeContent(
                body: additional.content,
                previousDeadline: previousDeadline,
                deadline: additional.deadline,
                createdAt: additional.createdAt,
              ),
            );
          },
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ZiggleButton(
                color: Colors.transparent,
                onTap: () {
                  HapticFeedback.mediumImpact();
                },
                child: Text(
                  t.notice.report,
                  style: const TextStyle(
                    fontSize: 14,
                    shadows: [
                      Shadow(
                        color: Palette.textGrey,
                        offset: Offset(0, -1),
                      ),
                    ],
                    color: Colors.transparent,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: Palette.textGrey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthorSettingSheet extends StatelessWidget {
  const _AuthorSettingSheet({
    required this.onEdit,
    required this.onAdditional,
    required this.onEnglish,
    required this.onDelete,
  });

  final VoidCallback? onEdit;
  final VoidCallback onAdditional;
  final VoidCallback? onEnglish;
  final VoidCallback onDelete;

  static void show({
    required BuildContext context,
    VoidCallback? onEdit,
    required VoidCallback onAdditional,
    VoidCallback? onEnglish,
    required VoidCallback onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Palette.white,
      builder: (modalContext) => _AuthorSettingSheet(
        onEdit: onEdit,
        onAdditional: onAdditional,
        onEnglish: onEnglish,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onEdit != null)
            ListTile(
              leading: Assets.icons.editPencil.svg(),
              title: Text(t.notice.edit),
              onTap: () {
                onEdit?.call();
                Navigator.pop(context);
              },
            ),
          ListTile(
            leading: Assets.icons.plus.svg(),
            title: Text(t.notice.writeAdditional),
            onTap: () {
              onAdditional();
              Navigator.pop(context);
            },
          ),
          if (onEnglish != null)
            ListTile(
              leading: Assets.icons.language.svg(),
              title: Text(t.notice.writeEnglish),
              onTap: () {
                onEnglish?.call();
                Navigator.pop(context);
              },
            ),
          ListTile(
            leading: Assets.icons.trash.svg(
              colorFilter: const ColorFilter.mode(
                Palette.primary100,
                BlendMode.srcIn,
              ),
            ),
            title: Text(
              t.notice.delete.action,
              style: const TextStyle(color: Palette.primary100),
            ),
            onTap: () async {
              final result = await showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  content: Text(t.notice.delete.confirm),
                  actions: [
                    AdaptiveDialogAction(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(t.notice.delete.delete),
                    ),
                    AdaptiveDialogAction(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(t.notice.delete.cancel),
                    ),
                  ],
                ),
              );
              if (result != true) return;
              onDelete();
              if (!context.mounted) return;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _ChipButton extends ZiggleButton {
  _ChipButton({
    super.child,
    super.onTap,
    bool selected = false,
  }) : super(
          color: selected ? Palette.black : Palette.backgroundGreyLight,
          textColor: selected ? Palette.background100 : Palette.black,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
        );
}

class _ReactionButton extends _ChipButton {
  _ReactionButton({
    required Widget icon,
    super.onTap,
    super.selected,
    required int count,
  }) : super(
          child: Row(
            children: [
              IconTheme(
                data: const IconThemeData(size: 20),
                child: SizedBox(
                  height: 24,
                  width: 20,
                  child: icon,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
}
