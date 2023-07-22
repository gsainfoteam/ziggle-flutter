import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ziggle/gen/strings.g.dart';

class FcmProvider {
  String? _token;
  final _controller = StreamController<String?>.broadcast();
  final _completer = Completer<void>();
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final _androidNotificationChannel = AndroidNotificationChannel(
    'ziggle_notification_channel',
    t.root.notificationChannelDescription,
    importance: Importance.max,
  );

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
    await instance.setForegroundNotificationPresentationOptions(
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

  void _androidMessageListener(RemoteMessage rm) async {
    final notification = rm.notification;

    if (notification != null && notification.android != null) {
      final imageUrl = notification.android?.imageUrl;
      final image = imageUrl == null
          ? null
          : await Dio(BaseOptions(responseType: ResponseType.bytes))
              .get(imageUrl)
              .then((value) => value.data);
      final styleInformation = image == null
          ? null
          : BigPictureStyleInformation(ByteArrayAndroidBitmap(image));
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidNotificationChannel.id,
            _androidNotificationChannel.name,
            styleInformation: styleInformation,
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
