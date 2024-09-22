import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ziggle/gen/strings.g.dart';

class LinkDialog extends StatefulWidget {
  const LinkDialog({
    super.key,
    required QuillController controller,
  }) : _controller = controller;

  final QuillController _controller;

  @override
  State<LinkDialog> createState() => _LinkDialogState();
}

class _LinkDialogState extends State<LinkDialog> {
  late final _initialTextLink = QuillTextLink.prepare(widget._controller);
  late final _text = TextEditingController(text: _initialTextLink.text);
  late final _link = TextEditingController(text: _initialTextLink.link ?? '');

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoTextField(
            placeholder: context.t.notice.write.link.text,
            controller: _text,
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 8),
          CupertinoTextField(
            placeholder: context.t.notice.write.link.link,
            controller: _link,
            onChanged: (v) => setState(() {}),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: _text.text.isEmpty ||
                  _link.text.isEmpty ||
                  !const AutoFormatMultipleLinksRule()
                      .oneLineLinkRegExp
                      .hasMatch(_link.text)
              ? null
              : () => Navigator.pop(
                    context,
                    QuillTextLink(_text.text, _link.text),
                  ),
          child: _initialTextLink.link == null
              ? Text(context.t.notice.write.link.add)
              : Text(context.t.notice.write.link.change),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(
            context,
            QuillTextLink(_text.text, null),
          ),
          child: Text(context.t.notice.write.link.remove),
        ),
      ],
    );
  }
}
