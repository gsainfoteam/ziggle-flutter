import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/sliver_pinned_header.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_content_entity.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/enums/notice_type.dart';
import '../../presentation/bloc/notice_bloc.dart';
import '../../presentation/widgets/additional_notice_content.dart';
import '../../presentation/widgets/notice_body.dart';

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
              if (notice.currentDeadline == null) return const SizedBox();
              if (notice.currentDeadline!.toLocal().isBefore(DateTime.now())) {
                return const SizedBox();
              }
              return IconButton(
                onPressed: () {},
                icon: Assets.icons.bell.svg(),
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
                            .format(notice.currentDeadline!),
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
                      notice.author,
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
                      DateFormat.yMd().add_Hm().format(notice.createdAt),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Palette.text300,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notice.contents.main.title,
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
                        .map((e) => e['name'] as String)
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
          itemCount: notice.imagesUrl.length,
          itemBuilder: (context, index) => Column(
            children: [
              const SizedBox(height: 10),
              Image.network(notice.imagesUrl[index]),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Assets.icons.fireFlame.svg(
                  height: 32,
                  fit: BoxFit.contain,
                ),
                padding: EdgeInsets.zero,
              ),
              const Text('67', style: TextStyle(fontWeight: FontWeight.w600)),
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
              const SizedBox(width: 8),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          sliver: SliverToBoxAdapter(
            child: BlocBuilder<NoticeBloc, NoticeState>(
              builder: (context, state) => state.loaded
                  ? NoticeBody(body: notice.contents.main.body)
                  : Text(notice.contents.main.body),
            ),
          ),
        ),
        SliverList.builder(
          itemCount: notice.contents.additionals.length,
          itemBuilder: (context, index) {
            final previous = notice.contents.locales.elementAt(index);
            final additional = notice.contents.additionals.elementAt(index);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: AdditionalNoticeContent(
                body: additional.body,
                previousDeadline: previous.deadline,
                deadline: additional.deadline,
                createdAt: additional.createdAt,
              ),
            );
          },
        ),
        const SliverToBoxAdapter(child: Divider()),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 20),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: DefaultTextStyle.merge(
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t.notice.views),
                    Text(
                      notice.views.toString(),
                      style: const TextStyle(color: Palette.textGreyDark),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverToBoxAdapter(
            child: Center(
              child: InkWell(
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
