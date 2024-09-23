import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_row_button.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/developer_option_bloc.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/strings.dart';
import 'package:ziggle/gen/strings.g.dart';

const _devModeCount = 10;

@RoutePage()
class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: context.t.user.setting.title,
        title: Text(context.t.user.setting.information.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ZiggleRowButton(
                title: Text(context.t.user.setting.information.termsOfService),
                onPressed: () => launchUrlString(Strings.termsOfServiceUrl),
              ),
              const SizedBox(height: 20),
              ZiggleRowButton(
                title: Text(context.t.user.setting.information.privacyPolicy),
                onPressed: () => launchUrlString(Strings.privacyPolicyUrl),
              ),
              const SizedBox(height: 20),
              ZiggleRowButton(
                title:
                    Text(context.t.user.setting.information.openSourceLicense),
                onPressed: () => const PackagesRoute().push(context),
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (data == null) return const SizedBox.shrink();
                  return Column(
                    children: [
                      ZiggleRowButton(
                        title: Text('v${data.version} (${data.buildNumber})'),
                        disabled: true,
                        showChevron: false,
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
              const _HiddenMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HiddenMenu extends StatefulWidget {
  const _HiddenMenu();

  @override
  State<_HiddenMenu> createState() => _HiddenMenuState();
}

class _HiddenMenuState extends State<_HiddenMenu> {
  int _count = 0;

  void _onClick() {
    if (_count >= _devModeCount) return;
    return setState(() {
      _count++;
      if (_count != _devModeCount) return;
      context.showToast(context.t.user.developMode.enabled);
      context
          .read<DeveloperOptionBloc>()
          .add(const DeveloperOptionEvent.enable());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeveloperOptionBloc, DeveloperOptionState>(
      builder: (context, state) => ZiggleRowButton(
        onPressed: state.enabled ? null : _onClick,
        title: Text(_count == _devModeCount
            ? context.t.user.developMode.enabled
            : _count > _devModeCount / 2
                ? '${_devModeCount - _count}'
                : context.t.user.setting.information.copyright),
        disabled: true,
        showChevron: false,
      ),
    );
  }
}
