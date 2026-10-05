// DRAF AI untuk AI Prompt Challenge Minggu 6
// Legenda penanda:
//   [ANDROID 13+] = perilaku khusus Android 13 ke atas
//   [iOS]         = perilaku khusus iOS
//   [NO-CONTEXT]  = bagian yang TIDAK boleh mengakses BuildContext/Riverpod

import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _topic = 'pengumuman-kampus';

final _local = FlutterLocalNotificationsPlugin();

// ---------------------------------------------------------------------------
// [NO-CONTEXT] Background handler: WAJIB top-level (bukan method kelas),
// karena berjalan di isolate terpisah.
// ---------------------------------------------------------------------------
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Jangan akses BuildContext, Riverpod, atau router di sini.
  // Navigasi dilakukan saat banner diklik (onMessageOpenedApp/getInitialMessage).
}

class PushService {
  PushService({required this.dio, required this.onNavigate});

  final Dio dio;

  /// Callback navigasi (mis. router.go). Dipasok dari luar supaya PushService
  /// tidak bergantung pada BuildContext.
  final void Function(String route) onNavigate;

  // -------------------------------------------------------------------------
  // 1. Inisialisasi
  // -------------------------------------------------------------------------
  Future<void> init() async {
    // Dipanggil setelah Firebase.initializeApp() di main().
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _initLocalNotifications();
    await requestPermission();
    await _syncToken();
    _listenForeground();
    _listenOpened();
    await _handleInitialMessage();
    await subscribePengumuman();
  }

  // -------------------------------------------------------------------------
  // 2. Permission
  // -------------------------------------------------------------------------
  Future<bool> requestPermission() async {
    // [iOS] Dialog izin wajib; status provisional juga dianggap diizinkan.
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // [ANDROID 13+] Izin runtime POST_NOTIFICATIONS. Butuh juga deklarasi
    // <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    // di AndroidManifest.xml.
    if (Platform.isAndroid) {
      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  // -------------------------------------------------------------------------
  // 3. Token lifecycle: getToken + onTokenRefresh -> POST /devices
  // -------------------------------------------------------------------------
  Future<void> _syncToken() async {
    // [iOS] getToken butuh APNs token lebih dulu; bila null, coba lagi nanti.
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) await _sendTokenToBackend(token);

    // WAJIB: token bisa berubah (reinstall, clear data, rotasi keamanan).
    FirebaseMessaging.instance.onTokenRefresh.listen(_sendTokenToBackend);
  }

  Future<void> _sendTokenToBackend(String token) async {
    // Jangan pernah mencetak token penuh.
    debugPrint('FCM token: ${token.substring(0, 12)}...');
    try {
      await dio.post('/devices', data: {
        'fcm_token': token,
        'platform': Platform.isAndroid ? 'android' : 'ios',
      });
    } catch (e) {
      debugPrint('Kirim token ke backend gagal: ${e.runtimeType}');
    }
  }

  // -------------------------------------------------------------------------
  // 4. Foreground: onMessage -> local notification manual
  // -------------------------------------------------------------------------
  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _local.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {
        // Klik banner lokal saat foreground.
        onNavigate(response.payload ?? '/');
      },
    );
  }

  void _listenForeground() {
    // [ANDROID] Saat foreground, sistem TIDAK menampilkan banner otomatis,
    // jadi tampilkan manual. [iOS] Banner foreground bisa diaktifkan lewat
    // setForegroundNotificationPresentationOptions, tetapi di sini tetap
    // memakai local notification agar perilaku sama di kedua platform.
    FirebaseMessaging.onMessage.listen((message) async {
      final route = routeFromData(message.data);
      const androidDetails = AndroidNotificationDetails(
        'pengumuman',
        'Pengumuman Kampus',
        importance: Importance.high,
        priority: Priority.high,
      );
      await _local.show(
        id: message.hashCode,
        title: message.notification?.title ?? 'Pengumuman',
        body: message.notification?.body ?? '',
        notificationDetails: const NotificationDetails(
          android: androidDetails,
          iOS: DarwinNotificationDetails(),
        ),
        payload: route,
      );
    });
  }

  // -------------------------------------------------------------------------
  // 5. Background -> diklik, dan Terminated -> dibuka dari notifikasi
  // -------------------------------------------------------------------------
  void _listenOpened() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onNavigate(routeFromData(message.data));
    });
  }

  Future<void> _handleInitialMessage() async {
    // Panggil setelah router dan status login siap, supaya guard tidak
    // membelokkan rute tujuan ke /login.
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) onNavigate(routeFromData(initial.data));
  }

  // -------------------------------------------------------------------------
  // 6. Topic messaging
  // -------------------------------------------------------------------------
  Future<void> subscribePengumuman() =>
      FirebaseMessaging.instance.subscribeToTopic(_topic);

  Future<void> unsubscribePengumuman() =>
      FirebaseMessaging.instance.unsubscribeFromTopic(_topic);
}

/// Fungsi murni: mudah diunit-test tanpa Firebase.
String routeFromData(Map<String, dynamic> data) {
  final route = (data['route'] as String?) ?? '/';
  return route.startsWith('/') ? route : '/$route';
}