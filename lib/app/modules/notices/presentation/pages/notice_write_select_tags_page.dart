import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_back_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/tag_bloc.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class NoticeWriteSelectTagsPage extends StatelessWidget {
  const NoticeWriteSelectTagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TagBloc>(),
      child: const _Layout(),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  final List<String> _tags = [];
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () => setState(() {
        final bloc = context.read<TagBloc>();
        final text = _controller.text;
        bloc.add(
          text.isEmpty ? const TagEvent.reset() : TagEvent.search(text),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar(
        leading: ZiggleBackButton(label: context.t.notice.write.configTitle),
        title: Text(context.t.notice.write.hashtag.title),
        actions: [
          ZiggleButton.text(
            onPressed: () => context.maybePop(_tags),
            child: Text(context.t.common.done),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ZiggleInput(
                    controller: _controller,
                    hintText: context.t.notice.write.hashtag.hint,
                    showBorder: false,
                  ),
                ),
                if (_controller.text.isNotEmpty)
                  ZigglePressable(
                    onPressed: () {
                      _tags.add(_controller.text.trim().replaceAll(' ', '_'));
                      _controller.clear();
                    },
                    child: const Icon(Icons.add),
                  )
              ],
            ),
            const Divider(color: Palette.grayBorder),
            if (_controller.text.isEmpty)
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => ZigglePressable(
                    onPressed: () => setState(() => _tags.removeAt(index)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Assets.icons.hashtag.svg(),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              _tags[index],
                              style: const TextStyle(
                                color: Palette.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: _tags.length,
                ),
              )
            else
              Expanded(
                child: BlocBuilder<TagBloc, TagState>(
                  builder: (context, state) => ListView.separated(
                    itemBuilder: (context, index) => ZigglePressable(
                      onPressed: () => setState(() {
                        _controller.clear();
                        _tags.add(state.tags[index].name);
                      }),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Assets.icons.search.svg(),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                state.tags[index].name,
                                style: const TextStyle(
                                  color: Palette.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: state.tags.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
