import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/common/presentation/functions/noop.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_management_bloc.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupManagementNamePage extends StatefulWidget {
  const GroupManagementNamePage({
    super.key,
    required this.uuid,
    required this.name,
  });

  final String uuid;
  final String name;

  @override
  State<GroupManagementNamePage> createState() =>
      _GroupManagementNamePageState();
}

class _GroupManagementNamePageState extends State<GroupManagementNamePage> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.name);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(noop));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        from: PageSource.setting,
        backLabel: context.t.group.manage.header,
        title: Text(context.t.group.manage.name.header),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  context.t.group.manage.name.groupName,
                  style: TextStyle(fontSize: 16, color: Palette.black),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ZiggleInput(
              hintText: context.t.group.manage.name.helpText,
              controller: _controller,
            ),
            const SizedBox(height: 30),
            BlocBuilder<GroupManagementBloc, GroupManagementState>(
              builder: (context, state) {
                return ZiggleButton.cta(
                  disabled: _controller.text.isEmpty ||
                      _controller.text == widget.name,
                  onPressed: () {
                    context
                        .read<GroupManagementBloc>()
                        .add(GroupManagementEvent.updateName(
                          widget.uuid,
                          _controller.text,
                        ));
                    context.router.maybePop();
                  },
                  child: Text(context.t.group.manage.change),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
