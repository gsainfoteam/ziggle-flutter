import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/groups/presentation/enums/group_creation_stage.dart';
import 'package:ziggle/app/modules/groups/presentation/widgets/progress_bar.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class GroupCreationPage extends StatefulWidget {
  const GroupCreationPage({super.key});

  @override
  State<GroupCreationPage> createState() => _GroupCreationPageState();
}

class _GroupCreationPageState extends State<GroupCreationPage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller = TabController(
    length: GroupCreationStage.values.length,
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(_changeHandler);
  }

  void _changeHandler() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _goBack(context),
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: Theme.of(context).appBarTheme.toolbarHeight,
          title: Text(t.group.create.title),
          leading: BackButton(onPressed: () => _goBack(context)),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProgressBar(
                  currentStage: _controller.index,
                  totalStage: 4,
                  title: t.group.create
                      .stage(context: GroupCreationStage.introduce),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: TabBarView(
                    controller: _controller,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _ProfileSetting(
                          onNext: () =>
                              _controller.animateTo(_controller.index + 1)),
                      _ProfileSetting(
                          onNext: () =>
                              _controller.animateTo(_controller.index + 1)),
                      _ProfileSetting(
                          onNext: () =>
                              _controller.animateTo(_controller.index + 1)),
                      _ProfileSetting(
                          onNext: () =>
                              _controller.animateTo(_controller.index + 1)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goBack(BuildContext context) {
    return _controller.index == 0
        ? Navigator.pop(context)
        : _controller.animateTo(_controller.index - 1);
  }
}

class _ProfileSetting extends StatefulWidget {
  const _ProfileSetting({required this.onNext});

  final VoidCallback onNext;

  @override
  State<_ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<_ProfileSetting> {
  String _name = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Assets.images.defaultGroupProfile.image(width: 300),
                  const SizedBox(height: 24),
                  ZiggleButton(
                    onTap: () {},
                    text: t.group.create.setGroupProfileImage,
                    color: Palette.background200,
                    textColor: Palette.black,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Palette.borderGreyLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  ZiggleTextField(
                    label: t.group.create.groupName.label,
                    hint: t.group.create.groupName.hint,
                    onChanged: (v) => setState(() => _name = v),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ZiggleButton(
          text: t.common.next,
          onTap: _name.isEmpty ? null : widget.onNext,
          color: _name.isEmpty ? const Color(0xfff7f7f7) : Palette.primary100,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
