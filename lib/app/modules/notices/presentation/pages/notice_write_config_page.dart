import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_bottom_sheet.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_toggle_button.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_write_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/deadline_selector.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/tag.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class NoticeWriteConfigPage extends StatefulWidget {
  const NoticeWriteConfigPage({super.key});

  @override
  State<NoticeWriteConfigPage> createState() => _NoticeWriteConfigPageState();
}

class _NoticeWriteConfigPageState extends State<NoticeWriteConfigPage> {
  DateTime? _deadline;
  NoticeType? _type;
  final List<String> _tags = [];

  void _save() {
    if (_type == null) return;
    context.read<NoticeWriteBloc>().add(NoticeWriteEvent.setConfig(
          deadline: _deadline,
          type: _type!,
          tags: _tags,
        ));
  }

  _publish() {
    _save();
    const NoticeWriteConsentRoute().push(context);
  }

  _preview() {
    _save();
    const NoticeWritePreviewRoute().push(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: context.t.common.cancel,
        from: PageSource.writeConfig,
        title: Text(context.t.notice.write.configTitle),
        actions: [
          ZiggleButton.text(
            disabled: _type == null,
            onPressed: () {
              AnalyticsRepository.click(
                  const AnalyticsEvent.writeConfigPublish());
              if (_type != null) {
                _publish();
              }
            },
            child: Text(
              context.t.notice.write.publish,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              children: [
                _buildDeadline(),
                const SizedBox(height: 25),
                _buildCategory(),
                const SizedBox(height: 25),
                _buildTags(),
                const SizedBox(height: 25),
                ZiggleButton.cta(
                  disabled: _type == null,
                  emphasize: false,
                  onPressed: () {
                    AnalyticsRepository.click(
                        const AnalyticsEvent.writeConfigPreview());
                    if (_type != null) {
                      _preview();
                    }
                  },
                  child: Text(context.t.notice.write.preview),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeadline() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Palette.grayLight,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Assets.icons.clock.svg(),
              const SizedBox(width: 6),
              Text.rich(
                context.t.notice.write.deadline.label(
                  small: (text) => TextSpan(
                    text: text,
                    style: const TextStyle(
                      color: Palette.gray,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Palette.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              ZiggleToggleButton(
                value: _deadline != null,
                onToggle: (v) async {
                  if (_deadline != null) {
                    setState(() => _deadline = null);
                    return;
                  }
                  final dateTime = await ZiggleBottomSheet.show<DateTime>(
                    context: context,
                    title: context.t.notice.write.deadline.title,
                    builder: (context) => DeadlineSelector(
                      onChanged: (v) => Navigator.pop(context, v),
                    ),
                  );
                  if (dateTime == null || !mounted) return;
                  setState(() => _deadline = dateTime);
                },
              ),
            ],
          ),
          if (_deadline != null) ...[
            const SizedBox(height: 10),
            ZigglePressable(
              onPressed: () async {
                final dateTime = await ZiggleBottomSheet.show<DateTime>(
                  context: context,
                  title: context.t.notice.write.deadline.title,
                  builder: (context) => DeadlineSelector(
                    initialDateTime: _deadline,
                    onChanged: (v) => Navigator.pop(context, v),
                  ),
                );
                if (dateTime == null || !mounted) return;
                setState(() => _deadline = dateTime);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Palette.grayBorder),
                ),
                child: Center(
                  child: Text(
                    DateFormat.yMd().add_jm().format(_deadline!),
                    style: const TextStyle(
                      color: Palette.grayText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategory() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Palette.grayLight,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Assets.icons.list.svg(),
              const SizedBox(width: 6),
              Text(
                context.t.notice.write.category,
                style: const TextStyle(
                  color: Palette.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: NoticeType.writable.indexed
                .expand(
                  (e) => [
                    if (e.$1 != 0) const SizedBox(width: 10),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ZigglePressable(
                          onPressed: () {
                            AnalyticsRepository.click(
                                AnalyticsEvent.writeConfigCategory(e.$2));
                            setState(() => _type = e.$2);
                          },
                          decoration: BoxDecoration(
                            color: _type == e.$2
                                ? Palette.black
                                : Palette.grayLight,
                            border: Border.all(
                              color: _type == e.$2
                                  ? Palette.black
                                  : Palette.grayBorder,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              e.$2.icon.svg(
                                height: 36,
                                colorFilter: _type == e.$2
                                    ? const ColorFilter.mode(
                                        Palette.white, BlendMode.srcIn)
                                    : null,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                e.$2.getName(context),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _type == e.$2
                                      ? Palette.white
                                      : Palette.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Palette.grayLight,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Assets.icons.hashtag.svg(),
              const SizedBox(width: 6),
              Text.rich(
                context.t.notice.write.hashtag.label(
                  small: (text) => TextSpan(
                    text: text,
                    style: const TextStyle(
                      color: Palette.gray,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Palette.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ZigglePressable(
            onPressed: () async {
              AnalyticsRepository.click(
                  const AnalyticsEvent.writeConfigAddHashtag());
              final tags = await const NoticeWriteSelectTagsRoute()
                  .push<List<String>>(context);
              if (!mounted || tags == null) return;
              setState(() => _tags
                ..clear()
                ..addAll(tags));
            },
            decoration: BoxDecoration(
              color: Palette.white,
              border: Border.all(color: Palette.grayBorder),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    context.t.notice.write.hashtag.hint,
                    style: const TextStyle(
                      color: Palette.gray,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_tags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags.indexed
                  .map(
                    (tag) => Tag(
                      tag: tag.$2,
                      onDelete: true,
                      onPressed: () {
                        AnalyticsRepository.click(
                            const AnalyticsEvent.writeConfigDeleteHashtag());
                        setState(() => _tags.removeAt(tag.$1));
                      },
                    ),
                  )
                  .toList(),
            )
          ],
        ],
      ),
    );
  }
}
