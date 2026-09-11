import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stats_provider.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: statsAsync.when(
        // 1. Kondisi Loading: tampilkan spinner
        loading: () => const Center(child: CircularProgressIndicator()),

        // 2. Kondisi Error: tampilkan pesan dan tombol Coba lagi
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(
                  'Gagal memuat statistik: ${err.toString().replaceAll('Exception: ', '')}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.read(statsProvider.notifier).refresh(),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),

        // 3. Kondisi Success: tampilkan data menggunakan property StatEntry
        data: (stats) => ListView.builder(
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final item = stats[index];
            return ListTile(
              leading: const Icon(Icons.bar_chart),
              title: Text(item.label),
              trailing: Text(
                '${item.value}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
