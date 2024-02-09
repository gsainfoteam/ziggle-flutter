import 'dart:async';

import 'package:flutter/services.dart';
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
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) _linkSubject.add(initialLink);
    } on PlatformException catch (_) {}
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
  Stream<String> getLinkStream() => _linkSubject.stream;
}
