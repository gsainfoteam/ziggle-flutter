import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/functions/noop.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_management_bloc.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupManagementNotionPage extends StatefulWidget {
  const GroupManagementNotionPage({
    super.key,
    required this.uuid,
    required this.notionLink,
  });

  final String uuid;
  final String? notionLink;

  @override
  State<GroupManagementNotionPage> createState() =>
      _GroupManagementNotionPageState();
}

class _GroupManagementNotionPageState extends State<GroupManagementNotionPage> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.notionLink);

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
    return BlocProvider(
      create: (context) => sl<GroupManagementBloc>(),
      child: Scaffold(
        appBar: ZiggleAppBar.compact(
          from: PageSource.groupManagement,
          backLabel: context.t.group.manage.header,
          title: Text(context.t.group.manage.notionLink.header),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          child: Column(
            children: [
              ZiggleInput(
                hintText: context.t.group.manage.notionLink.hintText,
                controller: _controller,
              ),
              SizedBox(height: 30),
              BlocBuilder<GroupManagementBloc, GroupManagementState>(
                builder: (context, state) {
                  return ZiggleButton.cta(
                    disabled: _controller.text.isEmpty ||
                        _controller.text == widget.notionLink,
                    child: Text(context.t.group.manage.change),
                    onPressed: () => context.read<GroupManagementBloc>().add(
                        GroupManagementEvent.updateNotionLink(
                            widget.uuid, _controller.text)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
