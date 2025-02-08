import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/notion_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/notion_page_builder.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/group_auth_bloc.dart';

class NotionPage extends StatelessWidget {
  const NotionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notion Demo')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () =>
                    context.read<GroupAuthBloc>().add(GroupAuthEvent.login()),
                child: Text('Login')),
            BlocBuilder<NotionBloc, NotionState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const Center(
                      child: Text('Press the button to load Notion data')),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  done: (data) {
                    final rootBlockId = data.keys.firstWhere(
                      (id) => (data[id]['type'] == 'page'),
                      orElse: () => '',
                    );
                    if (rootBlockId.isEmpty) {
                      return const Center(child: Text('No page block found'));
                    }
                    return NotionPageBuilder(
                      blocksMap: data,
                      rootBlockId: rootBlockId,
                    );
                  },
                  error: (msg) => Center(child: Text('Error: $msg')),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 원하는 pageId로 NotionBloc에 load 이벤트 보냄
          context.read<NotionBloc>().add(
                const NotionEvent.load(
                    pageId: '14a6b2ca6274800bb190e7a352393be3'
                    // '1292632a-e498-43a7-9fb3-e554c6a926c1',
                    ),
              );
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
