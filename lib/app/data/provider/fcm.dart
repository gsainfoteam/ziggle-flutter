import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ziggle/gen/strings.g.dart';

class FcmProvider {
  String? _token;
  final _tokenController = StreamController<String?>.broadcast();
  final _linkController = StreamController<String>.broadcast();
  String? _lastLink;
  final _completer = Completer<void>();
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final _androidNotificationChannel = AndroidNotificationChannel(
    'ziggle_notification_channel',
    t.root.notificationChannelDescription,
    importance: Importance.max,
  );

  FcmProvider() {
    _tokenController.stream.listen((event) {
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
    _tokenController.add(fcmToken);
    instance.onTokenRefresh.listen(_tokenController.add);
    instance.getInitialMessage().then((rm) {
      final path = rm?.data['path'];
      if (path == null || path is! String || path.isEmpty) return;
      _linkController.add(path);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((rm) {
      final path = rm.data['path'];
      if (path == null || path is! String || path.isEmpty) return;
      _linkController.add(path);
    });
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
      onDidReceiveBackgroundNotificationResponse: (details) {
        final payload = details.payload;
        if (payload == null || payload.isEmpty) return;
        final json = jsonDecode(payload);
        final path = json['path'];
        if (path == null || path is! String || path.isEmpty) return;
        _linkController.add(path);
      },
    );
    _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((value) {
      if (value == null) return;
      if (!value.didNotificationLaunchApp) return;
      final payload = value.notificationResponse?.payload;
      if (payload == null || payload.isEmpty) return;
      final json = jsonDecode(payload);
      final path = json['path'];
      if (path == null || path is! String || path.isEmpty) return;
      _linkController.add(path);
    });
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
        payload: rm.data.toString(),
      );
    }
  }

  Stream<String?> getFcmToken() async* {
    await _completer.future;
    yield _token;
    yield* _tokenController.stream;
  }

  Stream<String> getLink() async* {
    await _completer.future;
    if (_lastLink != null) {
      yield _lastLink!;
    }
    yield* _linkController.stream;
  }
}
