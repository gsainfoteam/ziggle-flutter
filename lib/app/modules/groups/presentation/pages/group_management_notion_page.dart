import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/functions/noop.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_input.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/group_management_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/notion_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/notion_page_builder.dart';
import 'package:ziggle/gen/assets.gen.dart';
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

  late final NotionBloc _notionBloc;
  late final BehaviorSubject<String> _subject;
  late final StreamSubscription<String> _subscription;

  @override
  void initState() {
    super.initState();
    _notionBloc = sl<NotionBloc>()
      ..add(NotionEvent.load(notionLink: widget.notionLink ?? ''));

    _subject = BehaviorSubject<String>();

    _subscription =
        _subject.debounceTime(const Duration(seconds: 1)).listen((notionLink) {
      if (mounted) {
        _notionBloc.add(NotionEvent.load(notionLink: notionLink));
      }
    });

    _controller.addListener(() {
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
              SizedBox(height: 15),
              BlocBuilder<NotionBloc, NotionState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox(),
                    loading: () => Container(
                      height: 159,
                      padding: EdgeInsets.all(25),
                      decoration: ShapeDecoration(
                        color: Color(0xFFF5F5F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Center(
                              child: Lottie.asset(Assets.lotties.loading,
                                  height:
                                      MediaQuery.of(context).size.width * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2)),
                          Text(
                            '노션 불러오는 중...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF6E6E73),
                              fontSize: 16,
                              fontFamily: 'Pretendard Variable',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    done: (data) {
                      final rootBlockId = data.keys.firstWhere(
                        (id) => (data[id]['type'] == 'page'),
                        orElse: () => '',
                      );
                      if (rootBlockId.isEmpty) {
                        return const Center(child: Text('No page block found'));
                      }
                      return Column(
                        children: [
                          SizedBox(
                            height: 446,
                            child: NotionPageBuilder(blocksMap: data),
                          ),
                          SizedBox(height: 30),
                        ],
                      );
                    },
                    error: (message) => Text(message),
                  );
                },
              ),
              SizedBox(height: 15),
              BlocBuilder<GroupManagementBloc, GroupManagementState>(
                builder: (context, state) {
                  return ZiggleButton.cta(
                    disabled: _controller.text.isEmpty ||
                        _controller.text == widget.notionLink,
                    child: Text(context.t.group.manage.change),
                    onPressed: () {
                      context.read<GroupManagementBloc>().add(
                          GroupManagementEvent.updateNotionLink(
                              widget.uuid, _controller.text));
                      context.router.maybePop();
                    },
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
