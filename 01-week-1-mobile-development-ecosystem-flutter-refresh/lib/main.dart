import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Mahasiswa',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Profil Mahasiswa'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.person, size: 100),
              SizedBox(height: 16),
              Text(
                'Nurfinka Lailasari',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('NIM: 244107020211'),
              SizedBox(height: 8),
              Text('Prodi: D4 Teknik Informatika'),
            ],
          ),
        ),
      ),
    );
  }
}