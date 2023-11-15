import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/common/presentaion/widgets/button.dart';
import 'package:ziggle/app/core/di/locator.dart';
import 'package:ziggle/app/core/routes/routes.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class RootPage extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final StatefulNavigationShell shell;
  final List<Widget> children;

  const RootPage({
    super.key,
    required this.items,
    required this.shell,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: _InnerPage(shell: shell, children: children),
      ),
      appBar: AppBar(
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Assets.logo.icon.image(alignment: Alignment.centerLeft),
        ),
        actions: [
          SizedBox(
            height: 45,
            child: ZiggleButton(
              color: Colors.transparent,
              onTap: () {
                final userBloc = context.read<AuthBloc>();
                if (userBloc.state.user == null) {
                  userBloc.add(const AuthEvent.logout());
                  sl<AnalyticsRepository>().logLogoutAnonymous();
                  return;
                }
                context.push(Paths.profile);
              },
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final name = state.user?.name;
                  if (name == null) return Row(children: [Text(t.root.login)]);
                  return Row(
                    children: [
                      Text(
                        name,
                        style: TextStyles.titleTextStyle.copyWith(
                          color: Palette.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Assets.icons.profile.image(),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.user == null) return const SizedBox.shrink();
          return ZiggleButton(
            color: Palette.primaryColor,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            onTap: () => context.push(Paths.write),
            child: const Icon(Icons.edit, color: Palette.white),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Palette.placeholder)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 50),
            Expanded(
              child: BottomNavigationBar(
                items: items,
                currentIndex: shell.currentIndex,
                onTap: (index) => shell.goBranch(index),
              ),
            ),
            const SizedBox(width: 50),
          ],
        ),
      ),
    );
  }
}

class _InnerPage extends StatefulWidget {
  const _InnerPage({
    required this.shell,
    required this.children,
  });

  final StatefulNavigationShell shell;
  final List<Widget> children;

  @override
  State<_InnerPage> createState() => _InnerPageState();
}

class _InnerPageState extends State<_InnerPage> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _InnerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateToPage(
      widget.shell.currentIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      onPageChanged: widget.shell.goBranch,
      children: widget.children,
    );
  }
}
