import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown/markdown.dart' show markdownToHtml;
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_entity.dart';
import '../bloc/write_bloc.dart';

class WriteForeignPage extends StatelessWidget {
  const WriteForeignPage({super.key, required this.notice});

  final NoticeEntity notice;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<WriteBloc>()),
      ],
      child: BlocConsumer<WriteBloc, WriteState>(
        listener: (context, state) => state.mapOrNull(
          error: (value) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(value.message)),
          ),
        ),
        builder: (context, state) => Stack(
          children: [
            IgnorePointer(ignoring: state.isLoading, child: _Layout(notice)),
            IgnorePointer(
              child: TweenAnimationBuilder(
                tween: Tween(
                  begin: state.isLoading ? 0.0 : 1.0,
                  end: state.isLoading ? 1.0 : 0.0,
                ),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: child,
                ),
                duration: const Duration(milliseconds: 100),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout(this.notice);

  final NoticeEntity notice;

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  String _title = '';
  String? _article;
  bool get _done => _title.isNotEmpty && _article != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Theme.of(context).appBarTheme.toolbarHeight,
        title: Text(t.notice.write.writeEnglish),
        actions: [
          ZiggleButton(
            onTap: _done
                ? () async {
                    final blob = context.read<WriteBloc>();
                    blob.add(WriteEvent.writeForeign(
                      notice: widget.notice,
                      title: _title,
                      content: markdownToHtml(_article!),
                    ));
                    final s = await blob.stream.firstWhere((s) => s.isLoaded);
                    if (!mounted) return;
                    context.pop(s.notice);
                  }
                : null,
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              t.notice.write.action,
              style: TextStyle(
                color: _done ? Palette.primary100 : Palette.textGrey,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextFormField(
                onChanged: (v) => setState(() => _title = v),
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isCollapsed: true,
                  hintText: t.notice.write.titleHint,
                  hintStyle: const TextStyle(color: Palette.textGrey),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(indent: 18, endIndent: 18),
            ListTile(
              onTap: () => WriteArticleRoute.create(
                title: t.notice.write.writeEnglish,
                hint: t.notice.write.enterEnglish,
                body: _article,
              ).push<String>(context).then((value) {
                if (!mounted) return;
                setState(() => _article = value ?? _article);
              }),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18),
              leading: Assets.icons.docs.svg(),
              horizontalTitleGap: 6,
              title: Text(
                t.notice.write.english,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _article != null
                        ? t.notice.write.edit
                        : t.notice.write.write,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Palette.textGrey,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Palette.textGrey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
