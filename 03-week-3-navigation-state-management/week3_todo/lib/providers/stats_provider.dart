import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model data statistik
class StatEntry {
  final String label;
  final int value;

  const StatEntry({required this.label, required this.value});
}

// Notifier pengelola state statistik
class StatsNotifier extends AsyncNotifier<List<StatEntry>> {
  final Random _random = Random();

  @override
  Future<List<StatEntry>> build() async {
    return _fetchStats();
  }

  // Dipanggil untuk mengambil ulang data saat tombol 'Coba lagi' ditekan
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchStats());
  }

  // Simulasi ambil data: delay 2 detik, 30% gagal, angka acak
  Future<List<StatEntry>> _fetchStats() async {
    // Delay 2 detik agar status loading terlihat
    await Future.delayed(const Duration(seconds: 2));

    // Peluang 30% gagal
    final gagal = _random.nextInt(100) < 30;
    if (gagal) {
      throw Exception('Gagal mengambil data statistik dari server');
    }

    // Angka acak untuk variasi nilai
    final selesai = _random.nextInt(26) + 5;
    final tertunda = _random.nextInt(15) + 1;
    final total = selesai + tertunda;

    return [
      StatEntry(label: 'Total Tugas', value: total),
      StatEntry(label: 'Tugas Selesai', value: selesai),
      StatEntry(label: 'Tugas Tertunda', value: tertunda),
    ];
  }
}

// Provider global untuk StatsNotifier
final statsProvider =
    AsyncNotifierProvider<StatsNotifier, List<StatEntry>>(StatsNotifier.new);
    