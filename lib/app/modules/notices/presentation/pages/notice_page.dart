import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/sliver_pinned_header.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_content_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/notice_body.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/enums/notice_type.dart';

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
                icon: Assets.icons.bell.image(),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final bloc = context.read<NoticeBloc>();
          bloc.add(NoticeEvent.load(bloc.state.notice));
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
            padding: const EdgeInsets.only(bottom: 20),
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
                Text(
                  notice.contents.localed.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
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
                  ? NoticeBody(body: notice.contents.localed.body)
                  : Text(notice.contents.localed.body),
            ),
          ),
        ),
        SliverList.separated(
          itemCount: notice.contents.additional.length,
          itemBuilder: (context, index) => Text(
            notice.contents.additional.elementAt(index).body,
          ),
          separatorBuilder: (context, index) => const Divider(),
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
