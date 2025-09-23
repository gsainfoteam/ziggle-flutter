import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_create_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/notion_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/layouts/group_creation_layout.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/notion_page_builder.dart';
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
        create: (context) => sl<NotionBloc>(),
        child: _Layout(),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupCreateBloc, GroupCreateState>(
      listener: (context, state) {
        state.whenOrNull(
          done: (_, __) {
            context.router.popUntilRouteWithName(
              GroupCreationProfileRoute.name,
            );
            context.replaceRoute(const GroupCreationDoneRoute());
          },
          error: (_, error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(error)));
          },
        );
      },
      child: Column(
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
            onChanged: (v) {
              context.read<GroupCreateBloc>().add(
                GroupCreateEvent.setNotionPageId(v),
              );
              context.read<NotionBloc>().add(NotionEvent.load(notionLink: v));
            },
            hintText: context.t.group.creation.notion.hint,
          ),
          Column(
            children: [
              SizedBox(height: 30),
              BlocBuilder<NotionBloc, NotionState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    done: (data) => NotionPageBuilder(blocksMap: data),
                    error: (error) => loading(error),
                    orElse: () =>
                        loading(context.t.group.creation.notion.loading),
                  );
                },
              ),
              SizedBox(height: 30),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ZiggleButton.cta(
                  outlined: true,
                  onPressed: () => context.maybePop(),
                  child: Text(context.t.common.back),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BlocBuilder<NotionBloc, NotionState>(
                  builder: (context, notionState) {
                    return BlocBuilder<GroupCreateBloc, GroupCreateState>(
                      builder: (context, state) {
                        return ZiggleButton.cta(
                          onPressed: () {
                            context.read<GroupCreateBloc>().add(
                              const GroupCreateEvent.create(),
                            );
                          },
                          loading: state.isLoading,
                          emphasize:
                              !state.isNotionPageIdEmpty &&
                              notionState.isNotionIdValid,
                          disabled:
                              !state.isNotionPageIdEmpty &&
                              !notionState.isNotionIdValid,
                          child: state.isNotionPageIdEmpty
                              ? Text(context.t.common.skip)
                              : Text(context.t.common.next),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget loading(String message) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F7),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: [
          Lottie.asset(Assets.lotties.loading, width: 80, height: 80),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(
              color: Palette.grayText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
