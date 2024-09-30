import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_create_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/layouts/group_creation_layout.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupCreationNotionPage extends StatelessWidget {
  const GroupCreationNotionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GroupCreationLayout(
      step: GroupCreationStep.notion,
      child: BlocProvider(
        create: (_) => sl<GroupCreateBloc>(),
        child: const _Layout(),
      ),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  String _notionPageId = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Assets.images.notion.image(width: 30),
            const SizedBox(width: 10),
            Text(
              context.t.group.creation.notion.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Palette.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text.rich(
          context.t.group.creation.notion.description(
            strong: (text) => TextSpan(
              text: text,
              style: const TextStyle(color: Palette.primary),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Palette.grayText,
          ),
        ),
        const SizedBox(height: 30),
        ZiggleInput(
          onChanged: (v) => setState(() => _notionPageId = v),
          hintText: context.t.group.creation.notion.hint,
        ),
        const SizedBox(height: 30),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F7),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Column(
            children: [
              const Text('...'),
              const SizedBox(height: 10),
              Text(
                context.t.group.creation.notion.loading,
                style: const TextStyle(
                  color: Palette.grayText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: ZiggleButton.cta(
                outlined: true,
                child: Text(context.t.common.back),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ZiggleButton.cta(
                emphasize: false,
                onPressed: () {
                  context.router
                      .popUntilRouteWithName(GroupCreationProfileRoute.name);
                  context.replaceRoute(const GroupCreationDoneRoute());
                },
                child: Text(context.t.common.skip),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ZiggleButton.cta(
                onPressed: () {
                  context
                      .read<GroupCreateBloc>()
                      .add(GroupCreateEvent.setNotionPageId(_notionPageId));
                  context.router
                      .popUntilRouteWithName(GroupCreationProfileRoute.name);
                  context.replaceRoute(const GroupCreationDoneRoute());
                },
                child: Text(context.t.common.next),
              ),
            ),
          ],
        )
      ],
    );
  }
}
