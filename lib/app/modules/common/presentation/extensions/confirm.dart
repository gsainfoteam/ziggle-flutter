import 'package:flutter/cupertino.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

extension BuildContextX on BuildContext {
  Future<T?> showDialog<T>({
    required String title,
    required String content,
    required void Function(BuildContext) onConfirm,
  }) =>
      showCupertinoDialog(
        context: this,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              textStyle: const TextStyle(color: Palette.gray),
              child: Text(context.t.common.cancel),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => onConfirm(context),
              child: Text(context.t.common.confirm),
            ),
          ],
        ),
      );
}
