import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _androidNotificationChannel = AndroidNotificationChannel(
  'ziggle_notification_channel',
  '지글 알림',
  importance: Importance.max,
);

class FcmProvider {
  String? _token;
  final _controller = StreamController<String?>.broadcast();
  final _completer = Completer<void>();
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
    _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidNotificationChannel);
    FirebaseMessaging.onMessage.listen(_androidMessageListener);
  }

  void _androidMessageListener(RemoteMessage rm) {
    final notification = rm.notification;

    if (notification != null && notification.android != null) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidNotificationChannel.id,
            _androidNotificationChannel.name,
          ),
        ),
      );
    }
  }

  Stream<String?> getFcmToken() async* {
    await _completer.future;
    yield _token;
    yield* _controller.stream;
  }
}
