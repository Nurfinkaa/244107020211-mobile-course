import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'route_from_message.dart';

final _local = FlutterLocalNotificationsPlugin();

// ---- Izin notifikasi ----

Future<bool> requestNotificationPermission() async {
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    announcement: false,
    carPlay: false,
    criticalAlert: false,
  );
  debugPrint('Izin FCM: ${settings.authorizationStatus}');
  return settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional;
}

Future<void> initLocalNotifications({
  required void Function(String route) onTap,
}) async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();
  await _local.initialize(
    settings: const InitializationSettings(android: android, iOS: ios),
    onDidReceiveNotificationResponse: (response) {
      // Klik banner foreground -> masuk ke rute di payload.
      debugPrint('Banner lokal diklik, payload: ${response.payload}');
      onTap(response.payload ?? '/');
    },
  );

  // Android 13+: minta izin lewat plugin lokal juga.
  await _local
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}

// ---- Token lifecycle ----

Future<void> initFcmToken({
  required Future<void> Function(String token) onToken,
}) async {
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) await onToken(token);

  // Token bisa berubah (reinstall, clear data, rotasi keamanan).
  FirebaseMessaging.instance.onTokenRefresh.listen(onToken);

  await subscribePengumuman();
}

// ---- Topic messaging ----

Future<void> subscribePengumuman() =>
    FirebaseMessaging.instance.subscribeToTopic('pengumuman-kampus');

Future<void> unsubscribePengumuman() =>
    FirebaseMessaging.instance.unsubscribeFromTopic('pengumuman-kampus');

// ---- Background handler: wajib top-level ----

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Berjalan di isolate terpisah. Jangan akses BuildContext atau Riverpod.
  // Navigasi dilakukan saat banner diklik, bukan di sini.
}

void registerBackgroundHandler() {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

// ---- Tiga app state ----

void listenForeground(void Function(String route) go) {
  // Foreground: sistem TIDAK menampilkan banner, jadi tampilkan manual.
  FirebaseMessaging.onMessage.listen((message) async {
    debugPrint('onMessage diterima: ${message.data}');
    final route = routeFromMessage(message.data);
    const androidDetails = AndroidNotificationDetails(
      'pengumuman',
      'Pengumuman Kampus',
      importance: Importance.high,
      priority: Priority.high,
    );
    try {
      await _local.show(
        id: message.hashCode,
        title: message.notification?.title ?? 'Pengumuman',
        body: message.notification?.body ?? '',
        notificationDetails:
            const NotificationDetails(android: androidDetails),
        payload: route,
      );
      debugPrint('Banner lokal ditampilkan');
    } catch (e) {
      debugPrint('Gagal menampilkan banner lokal: $e');
    }
  });

  // Background -> banner sistem diklik.
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    debugPrint('onMessageOpenedApp: ${message.data}');
    go(routeFromMessage(message.data));
  });
}

Future<void> handleTerminated(void Function(String route) go) async {
  // Terminated -> aplikasi dibuka dari notifikasi.
  final initial = await FirebaseMessaging.instance.getInitialMessage();
  debugPrint('getInitialMessage: ${initial?.data}');
  if (initial != null) go(routeFromMessage(initial.data));
}
