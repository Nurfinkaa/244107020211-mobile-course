import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_dashboard/main.dart';

void main() {
  // ============================================================
  // TEST 1
  // Memastikan dashboard menggunakan 1 kolom
  // pada layar yang sempit.
  // ============================================================
  testWidgets('Dashboard satu kolom di layar sempit', (tester) async {
    // Mengatur ukuran layar menjadi 400 x 800
    tester.view.physicalSize = const Size(400, 800);

    // Device pixel ratio dibuat 1 agar ukuran fisik
    // sama dengan ukuran logical pixel.
    tester.view.devicePixelRatio = 1.0;

    // Mengembalikan ukuran layar setelah test selesai.
    addTearDown(tester.view.reset);

    // Menjalankan aplikasi.
    await tester.pumpWidget(const DashboardApp());

    // Mengambil Card pertama saja.
    // .first digunakan karena dashboard memiliki beberapa Card.
    final width = tester.getSize(find.byType(Card).first).width;

    // Pada layar sempit, lebar Card kurang dari 700.
    expect(width, lessThan(700));
  });

  // ============================================================
  // TEST 2
  // Memastikan dashboard menggunakan 2 kolom
  // pada layar yang lebar.
  // ============================================================
  testWidgets('Dashboard dua kolom di layar lebar', (tester) async {
    // Mengatur ukuran layar menjadi 1200 x 800
    tester.view.physicalSize = const Size(1200, 800);

    // Device pixel ratio dibuat 1.
    tester.view.devicePixelRatio = 1.0;

    // Mengembalikan ukuran layar setelah test selesai.
    addTearDown(tester.view.reset);

    // Menjalankan aplikasi.
    await tester.pumpWidget(const DashboardApp());

    // Mengambil Card pertama saja.
    final width = tester.getSize(find.byType(Card).first).width;

    // Pada layar lebar, lebar Card harus lebih dari 500.
    expect(width, greaterThan(500));
  });
}