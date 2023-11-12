import 'package:collection/collection.dart';
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
      body: AnimatedBranchContainer(
        currentIndex: shell.currentIndex,
        children: children,
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
            const SizedBox(width: 100),
            Expanded(
              child: BottomNavigationBar(
                items: items,
                currentIndex: shell.currentIndex,
                onTap: (index) => shell.goBranch(index),
              ),
            ),
            const SizedBox(width: 100),
          ],
        ),
      ),
    );
  }
}

class AnimatedBranchContainer extends StatelessWidget {
  /// Creates a AnimatedBranchContainer
  const AnimatedBranchContainer(
      {super.key, required this.currentIndex, required this.children});

  /// The index (in [children]) of the branch Navigator to display.
  final int currentIndex;

  /// The children (branch Navigators) to display in this container.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    print(children);
    return Stack(
        children: children.mapIndexed(
      (int index, Widget navigator) {
        return AnimatedScale(
          scale: index == currentIndex ? 1 : 1.5,
          duration: const Duration(milliseconds: 400),
          child: AnimatedOpacity(
            opacity: index == currentIndex ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: _branchNavigatorWrapper(index, navigator),
          ),
        );
      },
    ).toList());
  }

  Widget _branchNavigatorWrapper(int index, Widget navigator) => IgnorePointer(
        ignoring: index != currentIndex,
        child: TickerMode(
          enabled: index == currentIndex,
          child: navigator,
        ),
      );
}
