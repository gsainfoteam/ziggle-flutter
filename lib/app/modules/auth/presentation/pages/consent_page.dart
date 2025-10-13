import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/app/values/strings.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class ConsentPage extends StatelessWidget {
  const ConsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar(title: Text(context.t.user.consent.title)),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.t.user.consent.description,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        ZigglePressable(
          onPressed: () => launchUrlString(Strings.termsOfServiceUrl),
          child: Text(
            context.t.user.consent.fields.tos,
            style: const TextStyle(
              color: Palette.grayText,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        ZigglePressable(
          onPressed: () => launchUrlString(Strings.privacyPolicyUrl),
          child: Text(
            context.t.user.consent.fields.privacy,
            style: const TextStyle(
              color: Palette.grayText,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Spacer(),
        ZiggleButton.text(
          onPressed: () => WithdrawRoute().push(context),
          child: Text(
            context.t.user.consent.actions.disagree,
            style: TextStyle(color: Palette.grayText),
          ),
        ),
        const SizedBox(height: 10),
        ZiggleButton.cta(
          onPressed: () async {
            final bloc = context.read<UserBloc>();
            final waiter = bloc.stream.firstWhere((state) => state.isConsent);
            bloc.add(const UserEvent.consent());
            await waiter;
          },
          child: Text(context.t.user.consent.actions.agree),
        ),
      ],
    );
  }
}
