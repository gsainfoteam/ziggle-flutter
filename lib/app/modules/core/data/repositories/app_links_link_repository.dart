import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repositories/link_repository.dart';

@Singleton(order: -10)
class AppLinksLinkRepository implements LinkRepository {
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
  Stream<String> getLinkStream() => _linkSubject.stream.map((event) {
        final uri = Uri.parse(event);
        return uri.queryParameters['redirect'] ?? '/';
      });
}
