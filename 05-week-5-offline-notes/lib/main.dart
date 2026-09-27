import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/notes_page.dart';

Future<void> main() async {
  // === EKSPERIMEN HIVE (sementara, untuk AI Verification Checklist) ===
  await Hive.initFlutter();
  final box = await Hive.openBox('notes_hive_test');
  await box.add({'title': 'Test Hive', 'dirty': true});
  print('Isi box Hive: ${box.values.toList()}');
  // === akhir eksperimen ===

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
      title: 'Offline Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NotesPage(),
    );
  }
}
