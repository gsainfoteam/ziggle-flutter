import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/functions/noop.dart';
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
    return const GroupCreationLayout(
      step: GroupCreationStep.notion,
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
  final String _notionPageId = "";
  late final NotionBloc _notionBloc;
  late final TextEditingController _controller =
      TextEditingController(text: _notionPageId);
  late final BehaviorSubject<String> _subject;
  late final StreamSubscription<String> _subscription;

  @override
  initState() {
    super.initState();
    _notionBloc = sl<NotionBloc>()
      ..add(NotionEvent.load(notionLink: _notionPageId));
    _subject = BehaviorSubject<String>();
    _subscription = _subject.debounceTime(Duration(seconds: 1)).listen((event) {
      _notionBloc.add(NotionEvent.load(notionLink: event));
    });
    _controller.addListener(() {
      _notionBloc.add(const NotionEvent.edit());
      _subject.add(_controller.text);
      setState(noop);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _subject.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _notionBloc,
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
            controller: _controller,
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
                          emphasize: _controller.text.isNotEmpty,
                          onPressed: () {
                            context.read<GroupCreateBloc>().add(
                                GroupCreateEvent.setNotionPageId(
                                    _controller.text));
                            context
                                .read<GroupCreateBloc>()
                                .add(const GroupCreateEvent.create());
                            context.router.popUntilRouteWithName(
                                GroupCreationProfileRoute.name);
                            context
                                .replaceRoute(const GroupCreationDoneRoute());
                          },
                          disabled: _controller.text.isNotEmpty &&
                              !notionState.isNotionIdValid,
                          loading: state.isLoading,
                          child: _controller.text.isEmpty
                              ? Text(context.t.common.skip)
                              : Text(context.t.common.next),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )
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
          Lottie.asset(
            Assets.lotties.loading,
            width: 80,
            height: 80,
          ),
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
