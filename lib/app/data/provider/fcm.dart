import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class FcmProvider {
  String? _token;
  final _controller = StreamController<String?>.broadcast();
  final _completer = Completer<void>();

  FcmProvider() {
    _controller.stream.listen((event) {
      _token = event;
    });
    _load().then((value) {
      _completer.complete();
    });
  }

  Future<void> _load() async {
    final instance = FirebaseMessaging.instance;
    final settings = await instance.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }
    final fcmToken = await instance.getToken();
    _controller.add(fcmToken);
    instance.onTokenRefresh.listen(_controller.add);
    instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Stream<String?> getFcmToken() async* {
    await _completer.future;
    yield _token;
    yield* _controller.stream;
  }
}
