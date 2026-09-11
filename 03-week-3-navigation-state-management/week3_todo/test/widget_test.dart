import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:week3_todo/pages/stats_page.dart';
import 'package:week3_todo/providers/stats_provider.dart';

class FakeStatsNotifier extends StatsNotifier {
  @override
  Future<List<StatEntry>> build() async {
    return const [
      StatEntry(label: 'Total Tugas', value: 20),
      StatEntry(label: 'Tugas Selesai', value: 15),
      StatEntry(label: 'Tugas Tertunda', value: 5),
    ];
  }
}

void main() {
  testWidgets('StatsPage menampilkan loading', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          statsProvider.overrideWith(FakeStatsNotifier.new),
        ],
        child: const MaterialApp(
          home: StatsPage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}