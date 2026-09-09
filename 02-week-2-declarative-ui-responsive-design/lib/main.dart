import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const DashboardApp());

class DashboardApp extends StatefulWidget {
  const DashboardApp({super.key});

  @override
  State<DashboardApp> createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: DashboardPage(
        isDark: isDark,
        onDarkChanged: (value) => setState(() => isDark = value),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    required this.isDark,
    required this.onDarkChanged,
    super.key,
  });

  final bool isDark;
  final ValueChanged<bool> onDarkChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Overview'),
        actions: [
          Semantics(
            label: 'Tombol ganti mode gelap',
            toggled: isDark,
            child: CupertinoSwitch(
              value: isDark,
              onChanged: onDarkChanged,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 700 ? 2 : 1;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header profil, terpisah dari grid kartu info
                const ProfileCard(),
                const SizedBox(height: 16),
                // Grid kartu info, mengisi sisa layar sampai bawah
                Expanded(
                  child: GridView.count(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.6,
                    children: const [
                      InfoCard(title: 'Jadwal kelas hari ini', value: '2 kelas'),
                      InfoCard(title: 'Tugas minggu ini', value: '5 tugas'),
                      InfoCard(title: 'Kehadiran', value: '92%'),
                      InfoCard(title: 'Portofolio', value: 'Ready'),
                      InfoCard(title: 'SKS diambil', value: '20 SKS'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'Profil mahasiswa Nurfinka Lailasari, NIM 244107020211, kelas TI-3G',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(child: Icon(Icons.person)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Nurfinka Lailasari',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('NIM   : 244107020211'),
                  Text('Kelas : TI-3G'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({required this.title, required this.value, super.key});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title: $value',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(child: Text(title)),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
      ),
    );
  }
}