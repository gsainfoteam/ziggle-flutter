import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:uni_links/uni_links.dart';
import 'package:ziggle/app/common/domain/repositories/deep_link_repository.dart';
import 'package:ziggle/app/core/routes/routes.dart';

@Singleton(as: DeepLinkRepository)
class UniLinksDeepLinkRepository implements DeepLinkRepository {
  String? _latestLink;
  final _controller = StreamController<String>.broadcast();
  final _completer = Completer<void>();

  UniLinksDeepLinkRepository() {
    _init();
  }

  Future<void> _init() async {
    _latestLink = await getInitialLink();
    if (_latestLink != null) {
      _controller.add(_latestLink!);
    }
    _completer.complete();
    linkStream.listen((link) {
      _latestLink = link;
      _controller.add(_latestLink!);
    });
  }

  Stream<String> _getLink() async* {
    await _completer.future;
    if (_latestLink != null) {
      yield _latestLink!;
    }
    yield* _controller.stream;
  }

  @override
  Stream<String> getLink() => _getLink().map((link) {
        final uri = Uri.parse(link);
        if (uri.path == '/app') {
          final redirect = (uri.queryParameters['redirect'] ?? '')
              .replaceFirst('/notice', '/article')
              .replaceFirst('/mypage', '/profile');
          if (redirect.isNotEmpty) return '/root$redirect';
          return Paths.home;
        }
        return uri.toString();
      });
}
