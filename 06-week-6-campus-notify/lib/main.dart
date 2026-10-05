import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'messaging/push_service.dart';
import 'pages/announcement_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'providers/auth_provider.dart';

// Container global supaya GoRouter bisa membaca status login.
final container = ProviderContainer();

// Memicu GoRouter menjalankan ulang redirect saat status login berubah.
final _authRefresh = ValueNotifier<int>(0);

final router = GoRouter(
  refreshListenable: _authRefresh,
  redirect: (context, state) {
    final loggedIn = container.read(authStateProvider).value ?? false;
    final goingLogin = state.matchedLocation == '/login';
    if (!loggedIn && !goingLogin) return '/login';
    if (loggedIn && goingLogin) return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
    GoRoute(path: '/', builder: (_, _) => const HomePage()),
    GoRoute(
      path: '/pengumuman/:id',
      builder: (_, s) => AnnouncementPage(id: s.pathParameters['id'] ?? ''),
    ),
  ],
);

void go(String route) => router.go(route);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  registerBackgroundHandler();
  container.listen(authStateProvider, (_, _) => _authRefresh.value++);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );

  await initLocalNotifications(onTap: go);
  await requestNotificationPermission();
  listenForeground(go);

  // Terminated: tunggu status login selesai dibaca supaya rute tujuan
  // tidak dibelokkan guard ke /login.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await container.read(authStateProvider.future);
    await handleTerminated(go);
  });

  final dio = container.read(apiClientProvider);
  await initFcmToken(onToken: (token) async {
    // Jangan pernah mencetak token penuh (aturan keamanan codelab).
    debugPrint('FCM token: ${token.substring(0, 12)}...');
    try {
      await dio.post(
        '/devices',
        data: {'fcm_token': token, 'platform': 'android'},
      );
    } catch (e) {
      // Backend codelab hanya contoh, jadi request ini wajar gagal.
      debugPrint('Kirim token ke backend gagal: ${e.runtimeType}');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Campus Notify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}
