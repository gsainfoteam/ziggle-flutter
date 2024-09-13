part of 'routes.dart';

@TypedShellRoute<NoticeShellRoute>(routes: [
  TypedGoRoute<NoticeWriteBaseRoute>(path: '/write'),
  TypedGoRoute<NoticeWriteRoute>(path: '/write/:step'),
  TypedGoRoute<NoticeWriteSheetRoute>(path: '/write/sheet/:step'),
])
class NoticeShellRoute extends ShellRouteData {
  @override
  Widget builder(context, state, navigator) => navigator;
}

class NoticeWriteBaseRoute extends GoRouteData {
  const NoticeWriteBaseRoute();
  @override
  FutureOr<String?> redirect(context, state) =>
      const NoticeWriteRoute().location;
}

enum NoticeWriteStep { body, config }

class NoticeWriteRoute extends GoRouteData {
  const NoticeWriteRoute([this.step = NoticeWriteStep.body]);

  final NoticeWriteStep step;

  @override
  Page<void> buildPage(context, state) {
    final page = {
          NoticeWriteStep.body: const NoticeWriteBodyPage(),
          NoticeWriteStep.config: const NoticeWriteConfigPage(),
        }[step] ??
        const SizedBox.shrink();
    return MaterialExtendedPage(child: page);
  }
}

enum NoticeWriteSheetStep { tags, preview, consent }

class NoticeWriteSheetRoute extends GoRouteData {
  const NoticeWriteSheetRoute(this.step);

  final NoticeWriteSheetStep step;

  @override
  Page<void> buildPage(context, state) {
    final page = {
          NoticeWriteSheetStep.tags: const NoticeWriteSelectTagsPage(),
          NoticeWriteSheetStep.preview: const NoticeWritePreviewPage(),
          NoticeWriteSheetStep.consent: const NoticeWriteConsentPage(),
        }[step] ??
        const SizedBox.shrink();
    return CupertinoSheetPage(
      key: state.pageKey,
      child: page,
    );
  }
}
