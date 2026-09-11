import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/stats_page.dart';

void main() {
  // ProviderScope wajib digunakan karena aplikasi memakai Riverpod.
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Judul aplikasi.
      title: 'Week 3 - ToDo',

      // Tema aplikasi menggunakan Material 3.
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),

      // Halaman pertama yang ditampilkan adalah StatsPage.
      home: const StatsPage(),
    );
  }
}
