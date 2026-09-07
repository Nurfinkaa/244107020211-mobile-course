import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';   // ← tambahkan baris ini
import 'package:flutter_test/flutter_test.dart';

import 'package:responsive_dashboard/main.dart';

void main() {
  testWidgets('Menampilkan 1 kolom di layar sempit', (tester) async {
    // Atur ukuran layar jadi sempit (400px)
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const DashboardApp());
    await tester.pumpAndSettle();

    // Cek GridView punya crossAxisCount = 1
    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 1);
  });

  testWidgets('Menampilkan 2 kolom di layar lebar', (tester) async {
    // Atur ukuran layar jadi lebar (900px)
    tester.view.physicalSize = const Size(900, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const DashboardApp());
    await tester.pumpAndSettle();

    // Cek GridView punya crossAxisCount = 2
    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 2);
  });

  testWidgets('Toggle tema berfungsi', (tester) async {
    await tester.pumpWidget(const DashboardApp());
    await tester.pumpAndSettle();

    // Cari switch, pastikan awalnya OFF (mode terang)
    final switchFinder = find.byType(CupertinoSwitch);
    expect(tester.widget<CupertinoSwitch>(switchFinder).value, false);

    // Tap switch, pastikan berubah jadi ON (mode gelap)
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();
    expect(tester.widget<CupertinoSwitch>(switchFinder).value, true);
  });
}