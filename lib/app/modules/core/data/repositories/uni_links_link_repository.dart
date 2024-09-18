import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uni_links/uni_links.dart';

import '../../domain/repositories/link_repository.dart';

@singleton
class UniLinksLinkRepository implements LinkRepository {
  final _linkSubject = BehaviorSubject<String>();
  late final StreamSubscription<String?> _subscription;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    final initialLink = await getInitialLink().catchError((_) => null);
    if (initialLink != null) _linkSubject.add(initialLink);
    _subscription = linkStream.listen((link) {
      if (link != null) _linkSubject.add(link);
    });
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
