import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/confirm.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_back_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class WithdrawPage extends StatelessWidget {
  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar(
        leading: ZiggleBackButton(label: context.t.common.back),
        title: Text(context.t.user.withdraw.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: _Layout(),
        ),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.t.user.withdraw.description,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Spacer(),
        Row(
          children: [
            Expanded(
              child: ZiggleButton.cta(
                onPressed: () => context.maybePop(),
                outlined: true,
                child: Text(context.t.common.cancel),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ZiggleButton.cta(
                onPressed: () => context.showDialog(
                  title: context.t.user.withdraw.title,
                  content: context.t.user.withdraw.confirm,
                  onConfirm: (_) {},
                ),
                child: Text(context.t.user.withdraw.actions.withdraw),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
