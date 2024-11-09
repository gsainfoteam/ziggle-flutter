import 'package:flutter/cupertino.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

extension BuildContextX on BuildContext {
  Future<T?> showDialog<T>({
    required String title,
    required String content,
    void Function(BuildContext)? onConfirm,
    List<Widget> Function(BuildContext)? buildActions,
  }) =>
      showCupertinoDialog(
        context: this,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: buildActions != null
              ? buildActions(context)
              : [
                  CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(),
                    textStyle: const TextStyle(color: Palette.gray),
                    child: Text(context.t.common.cancel),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () => onConfirm == null
                        ? Navigator.of(context).pop()
                        : onConfirm.call(context),
                    child: Text(context.t.common.confirm),
                  ),
                ],
        ),
      );
}
