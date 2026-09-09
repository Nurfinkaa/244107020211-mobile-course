import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ============================================================
// REFRACTORING POINT 3:
// Breakpoint hanya didefinisikan satu kali di sini.
// ============================================================
const kWideBreakpoint = 700.0;

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

      // Tema terang
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),

      // Tema gelap
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
      ),

      // Mengubah tema berdasarkan nilai isDark
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
    // ============================================================
    // REFRACTORING POINT 2:
    // Mengambil Theme dari context supaya warna dan style
    // otomatis mengikuti Light Mode / Dark Mode.
    // ============================================================ 

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

          // ============================================================
          // REFRACTORING POINT 3:
          // Sebelumnya:
          // constraints.maxWidth >= 700
          //
          // Sekarang menggunakan konstanta kWideBreakpoint.
          // ============================================================
          final columns =
              constraints.maxWidth >= kWideBreakpoint ? 2 : 1;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const ProfileCard(),

                const SizedBox(height: 16),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.6,

                    // ====================================================
                    // REFRACTORING POINT 1:
                    // Semua kartu menggunakan reusable InfoCard.
                    // Tidak ada lagi duplikasi struktur Card.
                    // ====================================================
                    children: const [
                      InfoCard(
                        title: 'Jadwal kelas hari ini',
                        value: '2 kelas',
                      ),
                      InfoCard(
                        title: 'Tugas minggu ini',
                        value: '5 tugas',
                      ),
                      InfoCard(
                        title: 'Kehadiran',
                        value: '92%',
                      ),
                      InfoCard(
                        title: 'Portofolio',
                        value: 'Ready',
                      ),
                      InfoCard(
                        title: 'SKS diambil',
                        value: '20 SKS',
                      ),
                      InfoCard(
                        title: 'Catatan dosen',
                        value: 'Perlu revisi laporan praktikum minggu ini',
                      ),
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
    // ============================================================
    // REFRACTORING POINT 2:
    // Menggunakan Theme.of(context) untuk mendapatkan warna
    // dari tema aktif.
    // ============================================================
    final theme = Theme.of(context);

    return Semantics(
      label:
          'Profil mahasiswa Nurfinka Lailasari, NIM 244107020211, kelas TI-3G',
      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          // Mengikuti warna tema aktif
          color: theme.colorScheme.primaryContainer,

          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              child: Icon(Icons.person),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Nurfinka Lailasari',

                    // Menggunakan TextTheme dari tema
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    'NIM   : 244107020211',
                    style: theme.textTheme.bodyMedium,
                  ),

                  Text(
                    'Kelas : TI-3G',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// REFRACTORING POINT 1:
// InfoCard adalah reusable widget.
//
// Widget ini menerima:
// - title
// - value
//
// Sehingga kita tidak perlu membuat struktur Card berulang-ulang.
// ================================================================
class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.title,
    required this.value,
    super.key,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // REFRACTORING POINT 2:
    // Menggunakan Theme.of(context) untuk mendapatkan style tema.
    // ============================================================
    final theme = Theme.of(context);

    return Semantics(
      label: '$title: $value',

      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Row(
            children: [
              // Judul kartu
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge,
                ),
              ),

              // ========================================================
              // Flexible digunakan supaya value tidak memaksa layout
              // ketika teksnya panjang.
              // ========================================================
              Flexible(
                child: Text(
                  value,
                  style: theme.textTheme.headlineSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}