import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/common/presentaion/widgets/article_card.dart';
import 'package:ziggle/app/common/presentaion/widgets/button.dart';
import 'package:ziggle/app/common/presentaion/widgets/section_header.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/core/routes/routes.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/app/core/values/strings.dart';
import 'package:ziggle/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_search_query_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_summary_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_mine.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/presentation/bloc/notices/notices_bloc.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.profile.title),
        actions: [
          SizedBox(
            height: 45,
            child: ZiggleButton(
              text: t.profile.logout,
              color: Colors.transparent,
              onTap: () =>
                  context.read<AuthBloc>().add(const AuthEvent.logout()),
            ),
          )
        ],
      ),
      body: const _Layout(),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  final _blocs = Map.fromEntries(
      NoticeType.profile.map((e) => MapEntry(e, sl<NoticesBloc>())));
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        _blocs.forEach(
          (key, value) => value.add(
            NoticesEvent.fetch(
              NoticeSearchQueryEntity(limit: 1, my: key.mine),
            ),
          ),
        );
        await Future.wait(_blocs.entries.map(
          (e) => e.value.stream.firstWhere((event) => event.loaded),
        ));
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Profile(),
            const Divider(),
            _MyArticles(_blocs),
            StreamBuilder(
              stream: Rx.combineLatest(_blocs.values.map((e) => e.stream),
                  (values) => values.any((e) => e.notices.isNotEmpty)),
              builder: (context, snapshot) => snapshot.data ?? false
                  ? const Divider()
                  : const SizedBox.shrink(),
            ),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

class _Profile extends StatelessWidget {
  const _Profile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 38),
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) => current.user != null,
        builder: (context, state) => Column(
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundColor: Palette.white,
              child: Assets.icons.avatar.image(),
            ),
            const SizedBox(height: 30),
            _Info(title: t.profile.name, content: state.user!.name),
            const SizedBox(height: 25),
            _Info(title: t.profile.studentId, content: state.user!.studentId),
            const SizedBox(height: 25),
            _Info(title: t.profile.mail, content: state.user!.email),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _MyArticles extends StatelessWidget {
  final Map<NoticeType, NoticesBloc> _blocs;
  const _MyArticles(this._blocs);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _blocs.entries
          .map(
            (e) => BlocBuilder<NoticesBloc, NoticesState>(
              bloc: e.value,
              builder: (context, state) => state.notices.isEmpty
                  ? const SizedBox.shrink()
                  : _buildSection(
                      context: context,
                      type: e.key,
                      notice: state.notices.first,
                      total: state.total,
                    ),
            ),
          )
          .toList(),
    );
  }

  Padding _buildSection({
    required NoticeType type,
    required BuildContext context,
    required NoticeSummaryEntity notice,
    required int total,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 25,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(
            type: type,
            onTap: () => context.push(Paths.articleSection(type)),
          ),
          const SizedBox(height: 12),
          NoticeCard(
            notice: notice,
            direction: Axis.horizontal,
            onTap: () => context.push(Paths.articleDetail, extra: notice),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: ZiggleButton(
              color: Palette.light,
              text: t.profile.others(count: total - 1),
              textColor: Palette.black,
              textStyle: TextStyles.bigNormal,
              onTap: () => context.push(Paths.articleSection(type)),
            ),
          )
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyles.label),
        Text(content, style: TextStyles.secondaryLabelStyle),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final analytics = sl<AnalyticsRepository>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ZiggleButton(
            text: t.profile.privacyPolicy,
            color: Colors.transparent,
            textStyle: TextStyles.link,
            padding: EdgeInsets.zero,
            onTap: () {
              analytics.logOpenPrivacyPolicy();
              launchUrl(Uri.parse(privacyPolicyUrl));
            },
          ),
          const SizedBox(height: 25),
          ZiggleButton(
            text: t.profile.termsOfService,
            color: Colors.transparent,
            textStyle: TextStyles.link,
            padding: EdgeInsets.zero,
            onTap: () {
              analytics.logOpenTermsOfService();
              launchUrl(Uri.parse(termsOfServiceUrl));
            },
          ),
          const SizedBox(height: 25),
          ZiggleButton(
            text: t.profile.withdrawal,
            color: Colors.transparent,
            textStyle: TextStyles.link,
            padding: EdgeInsets.zero,
            onTap: () {
              analytics.logOpenWithdrawal();
              launchUrl(Uri.parse(withdrawalUrl));
            },
          ),
        ],
      ),
    );
  }
}
