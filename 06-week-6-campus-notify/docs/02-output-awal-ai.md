# Output awal AI (draf pertama `lib/messaging/push_service.dart`)

Ringkasan isi draf pertama dari AI sebelum diverifikasi dan diperbaiki:

- `requestNotificationPermission()` memakai `FirebaseMessaging.requestPermission`.
- `initLocalNotifications()` memakai variabel global `pendingDeepLink` untuk menyimpan rute dari klik banner foreground.
- `initFcmToken()` memanggil `getToken`, `onTokenRefresh.listen`, dan `subscribeToTopic('pengumuman-kampus')`.
- `firebaseMessagingBackgroundHandler` berupa fungsi top-level dengan `@pragma('vm:entry-point')`.
- `listenForeground()` memakai `onMessage` + `_local.show`, serta `onMessageOpenedApp`.
- `handleTerminated()` memakai `getInitialMessage()`.
- Rute dibaca langsung dari `message.data['route'] ?? '/'`.
- Pemanggilan `_local.initialize` dan `_local.show` memakai parameter posisional.

Catatan: draf ini kemudian diverifikasi dan diperbaiki, lihat `03-verifikasi-dan-perbaikan.md`.
Draf kedua yang dihasilkan dari prompt AI Challenge (dengan penanda Android 13+, iOS, dan bagian tanpa BuildContext) ada di `docs/push_service_draft_ai.dart`.

## Draf kode awal

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _local = FlutterLocalNotificationsPlugin();

Future<bool> requestNotificationPermission() async {
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true, badge: true, sound: true,
    announcement: false, carPlay: false, criticalAlert: false,
  );
  return settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional;
}

Future<void> initLocalNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();
  await _local.initialize(
    const InitializationSettings(android: android, iOS: ios),
    onDidReceiveNotificationResponse: (response) {
      // Klik banner foreground -> teruskan payload ke router.
      pendingDeepLink = response.payload;
    },
  );
}

String? pendingDeepLink;

Future<void> initFcmToken({
  required Future<void> Function(String token) onToken,
}) async {
  // 1. Ambil token saat ini dan kirim ke backend.
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) await onToken(token);

  // 2. Token bisa berubah (reinstall, clear data, rotasi keamanan).
  FirebaseMessaging.instance.onTokenRefresh.listen(onToken);

  // 3. Langganan topik kampus.
  await FirebaseMessaging.instance.subscribeToTopic('pengumuman-kampus');
}

Future<void> unsubscribePengumuman() =>
    FirebaseMessaging.instance.unsubscribeFromTopic('pengumuman-kampus');

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Jangan akses BuildContext / Riverpod di sini.
}

void registerBackgroundHandler() {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

void listenForeground(void Function(String route) go) {
  // Foreground: sistem tidak menampilkan banner, tampilkan manual.
  FirebaseMessaging.onMessage.listen((message) async {
    final route = message.data['route'] ?? '/';
    const androidDetails = AndroidNotificationDetails(
      'pengumuman', 'Pengumuman Kampus',
      importance: Importance.high, priority: Priority.high,
    );
    await _local.show(
      message.hashCode,
      message.notification?.title ?? 'Pengumuman',
      message.notification?.body ?? '',
      const NotificationDetails(android: androidDetails),
      payload: route,
    );
  });

  // Background -> diklik.
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    go(message.data['route'] ?? '/');
  });
}

Future<void> handleTerminated(void Function(String route) go) async {
  // Terminated -> dibuka dari notifikasi.
  final initial = await FirebaseMessaging.instance.getInitialMessage();
  if (initial != null) go(initial.data['route'] ?? '/');
  if (pendingDeepLink != null) go(pendingDeepLink!);
}
```

## Masalah yang terlihat pada draf ini

- `pendingDeepLink` adalah variabel global yang bisa menyimpan nilai basi dan tidak langsung memicu navigasi saat banner foreground diklik.
- Rute dibaca langsung dari `data['route']`, tanpa penanganan rute tanpa awalan `/`.
- `handleTerminated` bisa berjalan sebelum status login selesai dibaca, sehingga guard bisa membelokkan ke `/login`.
- `initialize` dan `show` memakai parameter posisional, tidak cocok dengan versi paket yang terpasang.
- Tidak ada `requestNotificationsPermission()` untuk Android 13+ dan tidak ada log untuk mendiagnosis kegagalan `_local.show`.
