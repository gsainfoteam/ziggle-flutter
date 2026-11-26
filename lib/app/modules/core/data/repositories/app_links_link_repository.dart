import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repositories/link_repository.dart';

@Singleton(order: -10)
class AppLinksLinkRepository implements LinkRepository {
  static const host = 'ziggle.gistory.me';

  /// 앱 링크로 열 수 있는 경로. 공지 ID는 정수다.
  ///
  /// Android의 `LinkActivity.isSupported`도 같은 규칙으로 링크를 거른다.
  /// 규칙을 바꾸면 그쪽도 함께 바꾼다.
  static final _allowedPaths = [RegExp(r'^/notice/\d+$')];

  final _linkSubject = BehaviorSubject<String>();
  late final StreamSubscription<String?> _subscription;
  final appLinks = AppLinks();

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    final initialLink =
        (await appLinks.getInitialLink().catchError((_) => null)) ??
        (await appLinks.getLatestLink().catchError((_) => null));
    if (initialLink != null) _linkSubject.add(initialLink.toString());
    _subscription = appLinks.uriLinkStream
        .map((l) => l.toString())
        .listen(_linkSubject.add);
  }

  @disposeMethod
  void destroy() {
    _subscription.cancel();
    _linkSubject.close();
  }

  @override
  Stream<String> getLinkStream() => _linkSubject.stream
      .map((event) => toAppPath(Uri.tryParse(event)))
      .whereType<String>();

  /// 앱 링크를 앱에서 열 경로로 바꾼다. 열 수 없는 링크는 `null`이다.
  ///
  /// - `https://ziggle.gistory.me/notice/123` → `/notice/123`
  /// - `https://ziggle.gistory.me/app?redirect=/notice/123` → `/notice/123`
  /// - `redirect`에는 웹의 앱 배너가 넣는 전체 URL도 올 수 있다.
  ///   `https://ziggle.gistory.me/app?redirect=https%3A%2F%2Fziggle.gistory.me%2Fnotice%2F123`
  ///   → `/notice/123`
  static String? toAppPath(Uri? uri) {
    if (uri == null || !_isZiggle(uri)) return null;
    var target = uri;
    if (_normalize(uri.path) == '/app') {
      final redirect = Uri.tryParse(uri.queryParameters['redirect'] ?? '');
      if (redirect == null) return null;
      // 상대 경로면 링크의 주소를, 전체 URL이면 그 주소를 확인한다.
      target = uri.resolveUri(redirect);
      if (!_isZiggle(target)) return null;
    }
    final path = _normalize(target.path);
    if (!_allowedPaths.any((p) => p.hasMatch(path))) return null;
    return path;
  }

  static bool _isZiggle(Uri uri) =>
      uri.isScheme('https') && uri.host.toLowerCase() == host;

  /// 끝에 붙은 `/`를 뗀다. 웹은 `/notice/123/`도 같은 화면으로 연다.
  static String _normalize(String path) => path.length > 1 && path.endsWith('/')
      ? path.substring(0, path.length - 1)
      : path;
}
