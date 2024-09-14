import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notice_list_bloc.dart';
import 'package:ziggle/app/modules/notices/presentation/widgets/notice_card.dart';
import 'package:ziggle/app/values/palette.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.grayLight,
      appBar: ZiggleAppBar.main(
        onTapSearch: () {},
        onTapWrite: () {},
      ),
      body: BlocProvider(
        create: (_) => sl<NoticeListBloc>()..add(const NoticeListEvent.load()),
        child: const _Layout(),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoticeListBloc, NoticeListState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            final bloc = context.read<NoticeListBloc>();
            final blocker = bloc.stream.firstWhere((state) => !state.isLoading);
            bloc.add(const NoticeListEvent.load());
            await blocker;
          },
          child: state.showLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  itemBuilder: (context, index) {
                    final notice = state.notices[index];
                    return NoticeCard(
                      onLike: () {},
                      onPressed: () {},
                      onShare: () {},
                      notice: notice,
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemCount: state.notices.length,
                ),
        );
      },
    );
  }
}
