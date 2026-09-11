import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:week3_todo/providers/stats_provider.dart';

// Fake notifier untuk kondisi sukses.
class FakeSuccessStatsNotifier extends StatsNotifier {
  @override
  Future<List<StatEntry>> build() async {
    return const [
      StatEntry(label: 'Total Tugas', value: 20),
      StatEntry(label: 'Tugas Selesai', value: 15),
      StatEntry(label: 'Tugas Tertunda', value: 5),
    ];
  }

  @override
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

// Fake notifier untuk kondisi error.
class FakeFailureStatsNotifier extends StatsNotifier {
  @override
  Future<List<StatEntry>> build() async {
    throw Exception('Gagal mengambil data statistik dari server');
  }
}

void main() {
  group('StatsNotifier', () {
    // Test loading.
    test('State awal adalah loading', () async {
      final container = ProviderContainer(
        overrides: [
          statsProvider.overrideWith(FakeSuccessStatsNotifier.new),
        ],
      );

      final future = container.read(statsProvider.future);

      expect(
        container.read(statsProvider).isLoading,
        isTrue,
      );

      await future;
      container.dispose();
    });

    // Test success.
    test('Berhasil menghasilkan 3 data statistik', () async {
      final container = ProviderContainer(
        overrides: [
          statsProvider.overrideWith(FakeSuccessStatsNotifier.new),
        ],
      );

      final data = await container.read(statsProvider.future);

      expect(data.length, 3);
      expect(data[0].label, 'Total Tugas');
      expect(data[1].label, 'Tugas Selesai');
      expect(data[2].label, 'Tugas Tertunda');

      container.dispose();
    });

    // Test error.
    test('Menghasilkan error saat gagal mengambil data', () async {
      final container = ProviderContainer(
        overrides: [
          statsProvider.overrideWith(FakeFailureStatsNotifier.new),
        ],
      );

      // Mulai menjalankan provider.
      container.read(statsProvider);

      // Tunggu proses asynchronous selesai.
      await Future.delayed(
        const Duration(milliseconds: 100),
      );

      final state = container.read(statsProvider);

      expect(state.hasError, isTrue);
      expect(
        state.error.toString(),
        contains(
          'Gagal mengambil data statistik dari server',
        ),
      );

      container.dispose();
    });

    // Test refresh.
    test('Refresh mengubah loading menjadi data', () async {
      final container = ProviderContainer(
        overrides: [
          statsProvider.overrideWith(FakeSuccessStatsNotifier.new),
        ],
      );

      await container.read(statsProvider.future);

      final refresh =
          container.read(statsProvider.notifier).refresh();

      expect(
        container.read(statsProvider).isLoading,
        isTrue,
      );

      await refresh;

      expect(
        container.read(statsProvider),
        isA<AsyncData<List<StatEntry>>>(),
      );

      container.dispose();
    });
  });
}