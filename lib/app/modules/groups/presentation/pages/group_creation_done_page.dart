import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_select.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_create_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_invite_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/layouts/group_creation_layout.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class GroupCreationDonePage extends StatelessWidget {
  const GroupCreationDonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GroupCreationLayout(
      step: GroupCreationStep.done,
      child: _Layout(),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  int? _duration;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GroupInviteBloc>(),
      child: Column(
        children: [
          Lottie.asset(Assets.lotties.complete, repeat: false),
          const SizedBox(height: 20),
          BlocBuilder<GroupCreateBloc, GroupCreateState>(
            builder: (context, state) {
              return Text(
                state.maybeMap(
                  done: (data) => context.t.group.creation.done
                      .title(name: data.group.name),
                  orElse: () => context.t.group.creation.done.title(name: ""),
                ),
                style: const TextStyle(
                  fontSize: 24,
                  color: Palette.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            context.t.group.creation.done.description,
            style: const TextStyle(
              fontSize: 18,
              color: Palette.grayText,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Container(
            decoration: const BoxDecoration(
              color: Palette.grayLight,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: const EdgeInsets.all(15),
            child: BlocBuilder<GroupInviteBloc, GroupInviteState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Assets.icons.link.svg(width: 24),
                        const SizedBox(width: 6),
                        Text(
                          context.t.group.creation.done.invite.title,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Palette.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<GroupCreateBloc, GroupCreateState>(
                      builder: (context, groupState) {
                        return ZiggleSelect(
                          value: _duration,
                          onChanged: (v) {
                            setState(() => _duration = v);
                            context.read<GroupInviteBloc>().add(
                                  GroupInviteEvent.create(
                                      groupState.maybeMap(
                                          done: (data) => data.group,
                                          orElse: () => throw StateError(
                                              'Group creation not completed')),
                                      v!),
                                );
                          },
                          hintText:
                              context.t.group.creation.done.invite.selectExpire,
                          entries: [
                            ZiggleSelectEntry(
                              value: 1,
                              label: context.t.common.duration.day(n: 1),
                            ),
                            ZiggleSelectEntry(
                              value: 3,
                              label: context.t.common.duration.day(n: 3),
                            ),
                            ZiggleSelectEntry(
                              value: 7,
                              label: context.t.common.duration.week(n: 1),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    state.maybeWhen(
                      orElse: () => Container(),
                      success: (code) => ZiggleButton.cta(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: code));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text(context.t.common.clipboard.success)),
                            );
                          },
                          emphasize: false,
                          child: Text(context.t.group.manage.invite.copy)),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          ZiggleButton.cta(
            onPressed: () => context.maybePop(),
            child: Text(context.t.group.creation.done.back),
          )
        ],
      ),
    );
  }
}
