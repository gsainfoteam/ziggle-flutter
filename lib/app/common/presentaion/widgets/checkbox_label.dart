import 'package:flutter/cupertino.dart';
import 'package:ziggle/app/core/themes/text.dart';

class CheckboxLabel extends StatelessWidget {
  final bool checked;
  final void Function(bool) onChanged;
  final String label;
  const CheckboxLabel({
    super.key,
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CupertinoCheckbox(
          value: checked,
          onChanged: (v) => onChanged(v == true),
        ),
        Text(
          label,
          style: checked ? TextStyles.label : TextStyles.secondaryLabelStyle,
        ),
      ],
    );
  }
}
