import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:week3_todo/pages/todo_page.dart';

void main() {
  testWidgets('menambah tugas baru muncul di daftar', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: TodoPage()),
      ),
    );

    expect(find.text('Belum ada tugas'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Belajar Flutter');
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    expect(find.text('Belajar Flutter'), findsOneWidget);
    expect(find.text('Belum ada tugas'), findsNothing);
  });
}