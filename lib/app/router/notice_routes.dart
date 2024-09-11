part of 'routes.dart';

@TypedShellRoute<NoticeShellRoute>(routes: [
  TypedGoRoute<NoticeWriteBaseRoute>(path: '/write'),
  TypedGoRoute<NoticeWriteRoute>(path: '/write/:step')
])
class NoticeShellRoute extends ShellRouteData {
  @override
  Widget builder(context, state, navigator) => navigator;
}

class NoticeWriteBaseRoute extends GoRouteData {
  const NoticeWriteBaseRoute();
  @override
  FutureOr<String?> redirect(context, state) => '';
}

enum NoticeWriteStep { body }

class NoticeWriteRoute extends GoRouteData {
  const NoticeWriteRoute([this.step = NoticeWriteStep.body]);

  final NoticeWriteStep step;

  @override
  Widget build(context, state) {
    final page = {
          NoticeWriteStep.body: const NoticeWriteBodyPage(),
        }[step] ??
        const SizedBox.shrink();
    return page;
  }
}
