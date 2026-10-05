class AppRoutes {
  static const login = '/login';
  static const home = '/';
  static const announcementPattern = '/pengumuman/:id';

  static String announcement(String id) => '/pengumuman/$id';
}

/// Fungsi murni: data payload FCM -> rute tujuan. Tanpa dependensi Firebase.
String routeFromMessage(Map<String, dynamic> data) {
  final route = (data['route'] as String?)?.trim();
  if (route == null || route.isEmpty) return AppRoutes.home;
  return route.startsWith('/') ? route : '/$route';
} 