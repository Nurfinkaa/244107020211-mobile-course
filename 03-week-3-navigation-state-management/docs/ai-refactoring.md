# Dokumentasi AI - Refactoring Challenge

## 1. Tujuan

AI digunakan sebagai bantuan dalam proses refactoring aplikasi ToDo pada Praktikum Week 3. Penggunaan AI difokuskan untuk membandingkan alternatif implementasi dan membantu memahami struktur kode.

## 2. Prompt yang Digunakan

### Prompt 1 - TodoTile

> Bagaimana cara memisahkan widget item ToDo menjadi widget `TodoTile` tersendiri agar kode `TodoPage` lebih pendek dan mudah diuji?

### Prompt 2 - Provider Filter

> Bagaimana cara membuat Provider turunan dari `todoListProvider` untuk menampilkan atau menghitung jumlah tugas yang belum selesai menggunakan Riverpod?

### Prompt 3 - GoRouter

> Bagaimana cara mengintegrasikan GoRouter pada aplikasi ToDo dengan route `/` untuk halaman daftar tugas dan `/stats` untuk halaman statistik, serta menggunakan NavigationBar untuk berpindah halaman?

## 3. Hasil dari AI

AI memberikan beberapa saran implementasi, yaitu:

1. Membuat widget `TodoTile` pada file terpisah.
2. Membuat `unfinishedTodoProvider` yang membaca `todoListProvider`.
3. Menggunakan `GoRouter` dengan route `/` dan `/stats`.
4. Menggunakan `NavigationBar` untuk berpindah antara halaman ToDo dan Statistik.
5. Mempertahankan `ProviderScope` pada root aplikasi.

## 4. Verifikasi Hasil AI

Hasil dari AI tidak langsung digunakan tanpa pengecekan. Implementasi diuji kembali menggunakan Flutter Analyzer dan Flutter Test.

Perubahan yang diterapkan berhasil digunakan pada aplikasi, antara lain:

- `TodoTile` berhasil digunakan untuk menampilkan item ToDo.
- `unfinishedTodoProvider` berhasil membaca daftar ToDo dan menghitung tugas yang belum selesai.
- GoRouter berhasil digunakan untuk navigasi halaman.
- `NavigationBar` dapat digunakan untuk berpindah antara halaman ToDo dan Statistik.
- Widget test digunakan untuk memastikan penambahan tugas bekerja.

## 5. Pengujian

Perintah yang digunakan:

```bash
flutter analyze
flutter test
```

Hasil pengujian dicatat setelah seluruh perubahan selesai diverifikasi.

## 6. Kesimpulan

AI digunakan sebagai alat bantu dalam proses refactoring dan pemahaman implementasi. Setiap saran yang diberikan AI diperiksa kembali dengan menjalankan aplikasi serta melakukan pengujian menggunakan `flutter analyze` dan `flutter test`.