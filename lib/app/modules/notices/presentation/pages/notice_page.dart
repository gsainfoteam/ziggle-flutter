import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/common/presentaion/widgets/bottom_sheet.dart';
import 'package:ziggle/app/common/presentaion/widgets/button.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/core/routes/routes.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/app/core/values/shadows.dart';
import 'package:ziggle/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_summary_entity.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notices/notices_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/reminder/reminder_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/report/report_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/notice_body.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/page_spinner.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticePage extends StatelessWidget {
  final NoticeSummaryEntity notice;
  const NoticePage({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<NoticesBloc>()..add(NoticesEvent.fetchOne(notice)),
        ),
        BlocProvider(
          create: (_) => sl<ReminderBloc>()..add(ReminderEvent.fetch(notice)),
        ),
        BlocProvider(create: (_) => sl<ReportBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ReminderBloc, ReminderState>(
            listenWhen: (previous, current) =>
                current.mapOrNull(loginRequired: (m) => true) ?? false,
            listener: (context, state) => showCupertinoDialog(
              context: context,
              barrierDismissible: true,
              builder: (dialogContext) => CupertinoAlertDialog(
                title: Text(t.article.reminderLogin.title),
                content: Text(t.article.reminderLogin.description),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      t.root.login,
                      style: const TextStyle(color: Palette.black),
                    ),
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      context.read<AuthBloc>().add(const AuthEvent.logout());
                    },
                  )
                ],
              ),
            ),
          ),
          BlocListener<ReportBloc, ReportState>(
            listenWhen: (previous, current) =>
                current.mapOrNull(confirm: (m) => true) ?? false,
            listener: (context, state) => showCupertinoDialog(
              context: context,
              barrierDismissible: true,
              builder: (dialogContext) => CupertinoAlertDialog(
                title: Text(t.article.report.title),
                content: Text(t.article.report.description),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(t.article.report.no),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      context
                          .read<ReportBloc>()
                          .add(ReportEvent.report(notice, true));
                      Navigator.pop(dialogContext);
                    },
                    child: Text(t.article.report.yes),
                  ),
                ],
              ),
            ),
          ),
        ],
        child: const _Layout(),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoticesBloc, NoticesState>(
          builder: (context, state) => Text(state.partial?.title ?? ''),
        ),
        actions: [
          BlocBuilder<NoticesBloc, NoticesState>(
            builder: (context, state) => state.partial?.currentDeadline == null
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: () => context
                        .read<ReminderBloc>()
                        .add(const ReminderEvent.toggle()),
                    icon: BlocBuilder<ReminderBloc, ReminderState>(
                      builder: (context, state) => Icon(
                        Icons.notifications_active,
                        color: state.value ? Palette.black : Palette.deselected,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<NoticesBloc, NoticesState>(
        builder: (context, state) => state.single == null ||
                context.read<AuthBloc>().state.user?.id !=
                    state.single!.authorId
            ? const SizedBox.shrink()
            : FloatingActionButton.extended(
                foregroundColor: Palette.white,
                backgroundColor: Palette.settings,
                icon: const Icon(Icons.settings),
                label: Text(t.article.settings.title),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (modalContext) => _SettingSheet(
                    onDelete: () async {
                      final bloc = context.read<NoticesBloc>();
                      bloc.add(
                        NoticesEvent.delete(
                          context.read<NoticesBloc>().state.partial!,
                        ),
                      );
                      await bloc.stream.firstWhere(
                          (s) => s.mapOrNull(initial: (_) => true) ?? false);
                      if (!context.mounted) return;
                      context.go(Paths.home);
                    },
                    onTranslation:
                        state.single!.contents.englishes.mains.isNotEmpty
                            ? null
                            : () async {
                                Navigator.pop(modalContext);
                                await context.push(
                                  Paths.articleTranslation(state.partial!.id),
                                  extra: state.single,
                                );
                                if (!context.mounted) return;
                                final bloc = context.read<NoticesBloc>();
                                bloc.add(
                                    NoticesEvent.fetchOne(bloc.state.partial!));
                              },
                    onAdditional: () async {
                      Navigator.pop(modalContext);
                      await context.push(
                        Paths.articleAdditional(state.partial!.id),
                        extra: state.single,
                      );
                      if (!context.mounted) return;
                      final bloc = context.read<NoticesBloc>();
                      bloc.add(NoticesEvent.fetchOne(bloc.state.partial!));
                    },
                  ),
                ),
              ),
      ),
      body: BlocBuilder<NoticesBloc, NoticesState>(
        builder: (context, state) => state.partial == null
            ? const Center(child: CircularProgressIndicator.adaptive())
            : _buildInner(state.single, state.partial!),
      ),
    );
  }

  Widget _buildInner(NoticeEntity? notice, NoticeSummaryEntity summary) {
    if (notice == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    final child = SafeArea(
      child: Builder(
        builder: (context) => NoticeBody(
          notice: notice,
          report: () =>
              context.read<ReportBloc>().add(ReportEvent.report(summary)),
        ),
      ),
    );

    if (notice.imagesUrl.isEmpty) {
      return Stack(
        children: [
          SingleChildScrollView(child: child),
          const _ReminderTooltip(),
        ],
      );
    }
    return _ScrollableDraggableContent(notice: notice, child: child);
  }
}

class _SettingSheet extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback? onTranslation;
  final VoidCallback onAdditional;
  const _SettingSheet({
    required this.onDelete,
    required this.onTranslation,
    required this.onAdditional,
  });

  @override
  Widget build(BuildContext context) {
    return ZiggleBottomSheet(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              _buildButton(
                Icons.delete,
                t.article.settings.delete.action,
                () async {
                  final result = await showCupertinoDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (dialogContext) => CupertinoAlertDialog(
                      title: Text(t.article.settings.delete.title),
                      content: Text(t.article.settings.delete.title),
                      actions: [
                        CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          onPressed: () => Navigator.pop(dialogContext, true),
                          child: Text(t.article.settings.delete.yes),
                        ),
                        CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(t.article.settings.delete.no),
                        ),
                      ],
                    ),
                  );
                  if (result == null || !result) return;
                  onDelete();
                },
              ),
              if (onTranslation != null) ...[
                const SizedBox(height: 12),
                _buildButton(
                  Icons.language,
                  t.article.settings.writeTranslation,
                  onTranslation!,
                ),
              ],
              const SizedBox(height: 12),
              _buildButton(
                Icons.add,
                t.article.settings.additional,
                onAdditional,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, VoidCallback onTap) {
    return ZiggleButton(
      onTap: onTap,
      color: Colors.transparent,
      textColor: Palette.black,
      padding: const EdgeInsets.all(8),
      child: Row(children: [Icon(icon), const SizedBox(width: 4), Text(label)]),
    );
  }
}

class _ScrollableDraggableContent extends StatefulWidget {
  final NoticeEntity notice;
  final Widget child;
  const _ScrollableDraggableContent({
    required this.notice,
    required this.child,
  });

  @override
  State<_ScrollableDraggableContent> createState() =>
      _ScrollableDraggableContentState();
}

class _ScrollableDraggableContentState
    extends State<_ScrollableDraggableContent> {
  double scrollPixel = 0.0;
  final scrollController = DraggableScrollableController();
  final pageController = PageController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () => setState(() => scrollPixel = scrollController.pixels),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          if (scrollPixel == 0) {
            scrollPixel = constraints.maxHeight * 0.25;
          }
          final minHeight = constraints.maxHeight * 0.25 + 15 * 2 + 20 + 43;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            height: max(constraints.maxHeight - scrollPixel, minHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: _buildImageCarousel(
                    widget.notice.id,
                    widget.notice.imagesUrl,
                  ),
                ),
                const SizedBox(height: 20),
                PageSpinner(
                  currentPage: page,
                  maxPage: widget.notice.imagesUrl.length,
                  onPageChanged: (page) => pageController.animateToPage(
                    page - 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  ),
                ),
              ],
            ),
          );
        }),
        const _ReminderTooltip(),
        DraggableScrollableSheet(
          controller: scrollController,
          initialChildSize: 0.25,
          builder: (context, scrollController) => ZiggleBottomSheet(
            scrollController: scrollController,
            child: widget.child,
          ),
        ),
      ],
    );
  }

  Widget _buildImageCarousel(int noticeId, List<String> imageUrls) {
    return PageView.builder(
      clipBehavior: Clip.none,
      controller: pageController,
      onPageChanged: (p) {
        setState(() => page = p + 1);
        sl<AnalyticsRepository>().logChangeImageCarousel(p);
      },
      itemCount: imageUrls.length,
      itemBuilder: (context, index) => Center(
        child: GestureDetector(
          onTap: () async {
            final result = await context.push<int>(
              Paths.articleImage(noticeId, index + 1),
              extra: imageUrls,
            );
            if (!mounted || result == null) return;
            pageController.jumpToPage(result - 1);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Palette.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: frameShadows,
              ),
              child: Hero(
                tag: index,
                child: CachedNetworkImage(
                  imageUrl: imageUrls[index],
                  fit: BoxFit.contain,
                  placeholder: (_, __) =>
                      const CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReminderTooltip extends StatelessWidget {
  const _ReminderTooltip();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final notice = context.watch<NoticesBloc>().state.single;
        final reminderState = context.watch<ReminderBloc>().state;
        return notice == null ||
                notice.reminder ||
                notice.currentDeadline == null ||
                !reminderState.showTooltip
            ? const SizedBox.shrink()
            : Positioned(
                top: 0,
                right: 20,
                child: _Tooltip(() => context
                    .read<ReminderBloc>()
                    .add(const ReminderEvent.dismiss())),
              );
      },
    );
  }
}

class _Tooltip extends StatelessWidget {
  final void Function()? onClose;
  const _Tooltip(this.onClose);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: _TriangleDecoration(),
        ),
        Container(
          padding: const EdgeInsets.only(right: 18),
          decoration: BoxDecoration(
            color: Palette.primary100,
            borderRadius: BorderRadius.circular(10) -
                const BorderRadius.only(topRight: Radius.circular(10)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close),
                iconSize: 20,
                color: Palette.white,
                padding: EdgeInsets.zero,
              ),
              Text(
                t.article.reminderDescription,
                style: TextStyles.tooltipStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TriangleDecoration extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _TrianglePainter();
  }
}

class _TrianglePainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..color = Palette.primary100
      ..style = PaintingStyle.fill;
    final bounds = offset & configuration.size!;
    final path = Path()
      ..moveTo(bounds.right, bounds.top)
      ..lineTo(bounds.right, bounds.bottom)
      ..lineTo(bounds.left, bounds.bottom)
      ..close();
    canvas.drawPath(path, paint);
  }
}
