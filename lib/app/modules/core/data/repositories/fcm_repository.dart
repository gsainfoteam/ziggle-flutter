import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/repositories/link_repository.dart';
import '../../domain/repositories/push_message_repository.dart';

@singleton
@dev
@prod
class FcmRepository implements PushMessageRepository, LinkRepository {
  final _tokenSubject = BehaviorSubject<String>();
  final _linkSubject = BehaviorSubject<String>();

  static final _androidNotificationChannel = AndroidNotificationChannel(
    'ziggle_notification_channel',
    t.setting.notifications.description,
    importance: Importance.max,
  );

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    await _initToken();
    _initRemoteMessage();
    await _setupForeground();
  }

  void _initRemoteMessage() {
    FirebaseMessaging.instance.getInitialMessage().then(_handleRemoteMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteMessage);
  }

  Future<void> _initToken() async {
    final instance = FirebaseMessaging.instance;
    await instance.requestPermission(announcement: true, provisional: true);
    final fcmToken = await instance.getToken();
    if (fcmToken != null) _tokenSubject.add(fcmToken);
    instance.onTokenRefresh.listen(_tokenSubject.add);
  }

  void _handleRemoteMessage(RemoteMessage? rm) {
    final path = rm?.data['path'];
    if (path == null || path is! String || path.isEmpty) return;
    _linkSubject.add(path);
  }

  void _handleForegroundMessage(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    final json = jsonDecode(payload);
    final path = json['path'];
    if (path == null || path is! String || path.isEmpty) return;
    _linkSubject.add(path);
  }

  Future<void> _setupForeground() async {
    final instance = FirebaseMessaging.instance;
    await instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    final localNotificationPlugin = FlutterLocalNotificationsPlugin();
    await localNotificationPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/ic_notification'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _handleForegroundMessage,
    );
    localNotificationPlugin.getNotificationAppLaunchDetails().then((value) {
      if (value == null || !value.didNotificationLaunchApp) return;
      final response = value.notificationResponse;
      if (response == null) return;
      _handleForegroundMessage(response);
    });
    await localNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidNotificationChannel);
    FirebaseMessaging.onMessage.listen(_androidMessageListener);
  }

  Future<void> _androidMessageListener(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    final android = message.notification?.android;
    if (android == null) return;
    final imageUrl = android.imageUrl;
    final image = imageUrl != null && imageUrl.isNotEmpty
        ? BigPictureStyleInformation(ByteArrayAndroidBitmap(
            await NetworkAssetBundle(Uri.parse(imageUrl))
                .load(imageUrl)
                .then((value) => value.buffer.asUint8List()),
          ))
        : null;
    FlutterLocalNotificationsPlugin().show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidNotificationChannel.id,
          _androidNotificationChannel.name,
          styleInformation: image,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  @override
  Stream<String> getTokenStream() => _tokenSubject.stream;

  @override
  Stream<String> getLinkStream() => _linkSubject.stream;

  @override
  Future<void> clearToken() async {
    final instance = FirebaseMessaging.instance;
    await instance.deleteToken();
    await instance.getToken();
  }
}
