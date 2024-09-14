import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_back_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeWriteSelectTagsPage extends StatefulWidget {
  const NoticeWriteSelectTagsPage({super.key});

  @override
  State<NoticeWriteSelectTagsPage> createState() =>
      _NoticeWriteSelectTagsPageState();
}

class _NoticeWriteSelectTagsPageState extends State<NoticeWriteSelectTagsPage> {
  final List<String> _tags = [];
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar(
        leading: ZiggleBackButton(label: t.notice.write.configTitle),
        title: Text(t.notice.write.hashtag.title),
        actions: [
          ZiggleButton.text(
            onPressed: () => context.pop(_tags),
            child: Text(t.common.done),
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
                    hintText: t.notice.write.hashtag.hint,
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
                    child: Row(
                      children: [
                        Assets.icons.check.svg(),
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
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: _tags.length,
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => ZigglePressable(
                    onPressed: () => setState(() {
                      _controller.clear();
                      _tags.add(_tags[index]);
                    }),
                    child: Text(
                      _tags[index],
                      style: const TextStyle(
                        color: Palette.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: _tags.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
