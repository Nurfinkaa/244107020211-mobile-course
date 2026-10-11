# Week 7 — Clean Architecture (feature-first)

Refactor project Minggu 5 (`week5_offline_notes`) menjadi Clean Architecture
feature-first. Project ini **lanjutan**, bukan project baru — perilaku aplikasi
dibuat identik dengan sebelum refactor (bukti: uji manual + screenshot
before/after di `screenshots/`).

## Tujuan

- Memisahkan tiga layer: `presentation` → `domain` ← `data`.
- Membuktikan dependency rule dengan tiga grep sterilitas (hasil di bawah).
- Menguji use case dengan repository palsu tanpa SQLite/Dio sungguhan.
- Latihan menilai usulan AI dan memutuskan struktur final sendiri
  (dokumentasi: `docs/refactoring-decisions.md`).

## Stack teknologi

- Flutter 3.47.2 / Dart 3.13.2
- Riverpod 3.4.3 (state management + dependency injection)
- GoRouter 18.0.1 (routing)
- sqflite 2.4.4 (database lokal notes + cache posts)
- Dio 5.11.1 (fetch JSONPlaceholder, fitur posts)
- shared_preferences, hive (tetap di pubspec; kode yang memakainya sudah
  dihapus karena tidak ber-rute — lihat `docs/refactoring-decisions.md`)

## Diagram layer dan arah dependensi

```
presentation (pages, widgets, providers, routes)
      |  bergantung ke
      v
domain (entity, repository interface, use case, failure)
      ^  diimplementasikan oleh
      |
data (model, repository impl, Dio, SQLite)
```

- `domain` tidak mengimpor Flutter/Dio/sqflite apa pun → bisa diuji murni.
- Widget tidak pernah menginstansiasi repository; wiring hanya di file
  `presentation/providers/*_providers.dart`.
- Kontrak error memakai record Dart: `({List<Note> notes, Failure? failure})`
  dengan `sealed class Failure` di `lib/core/failures.dart`.

## Struktur folder

```
lib/
├── core/
│   ├── failures.dart          # Failure, LocalFailure, NetworkFailure
│   └── format.dart            # parsing rute & label teks (murni Dart)
├── features/
│   ├── notes/
│   │   ├── domain/{entities, repositories, usecases}
│   │   ├── data/{local/db.dart, models, repositories}
│   │   └── presentation/{providers, pages, widgets}
│   └── posts/
│       ├── domain/{entities, repositories, usecases}
│       ├── data/{models, repositories}
│       └── presentation/{providers, pages}
├── routes.dart                # GoRouter + konstanta rute
└── main.dart
```

## Fitur utama

1. **Notes** — CRUD catatan offline (sqflite) dengan flag `dirty`, badge
   jumlah belum tersinkron, tombol sync (use case `SyncNotes`), halaman
   detail per catatan.
2. **Posts** — baca JSONPlaceholder dengan strategi cache-first
   (use case `GetPosts`: cache dulu, refresh di background, fallback ke
   cache saat jaringan gagal) + toggle "Force Offline" untuk simulasi.

## Cara menjalankan

```bash
flutter pub get
flutter run          # butuh emulator/perangkat
flutter analyze
flutter test
```

## Hasil verifikasi (dijalankan 12 Okt 2026)

**1. Presentation steril dari data mentah** — nol hasil:

```
$ rg -n "Dio\(|openDatabase|getDatabasesPath|FlutterSecureStorage|SharedPreferences\.getInstance|jsonDecode" lib/features --glob "**/presentation/**"
exit=1 (nol hasil)
```

**2. Domain + core steril dari framework** — nol hasil:

```
$ rg -n "import 'package:flutter|import 'package:dio|import 'package:sqflite|import 'package:firebase" lib/features lib/core --glob "**/domain/**" --glob "lib/core/**"
exit=1 (nol hasil)
```

**3. Instansiasi manual repository di pages/providers** — folder lama
sudah tidak ada, tidak ada yang bisa melanggar:

```
$ rg -n "Repository\(|Dio\(BaseOptions" lib/pages lib/providers
rg: lib/pages: The system cannot find the file specified.
rg: lib/providers: The system cannot find the file specified.
```

**4. Static analysis + test:**

```
$ flutter analyze
No issues found!

$ flutter test
00:01 +14: All tests passed!
```

14 test: `GetNotes` (sukses + failure), `SyncNotes` (3 skenario),
`GetPosts` (3 skenario), mapping `NoteModel` (3), `core/format` (3) —
semua memakai repository palsu yang `implements` interface, tanpa
database/jaringan sungguhan.

## Screenshot before/after

Lihat `screenshots/README.md` untuk daftar bukti yang diambil saat uji
manual 5 menit per fitur.

## Refleksi singkat

- Interface repository hidup di domain karena yang membutuhkan kontrak
  adalah domain/presentation; bila dibalik, domain ikut tercemar detail
  sqflite/Dio dan test use case tidak bisa murni.
- Use case baru sepadan saat ada aturan bisnis (`SyncNotes`, `GetPosts`
  cache-first). CRUD satu-baris sengaja tidak dibungkus use case — kelas
  pass-through justru menambah biaya baca.
- Bagian usulan AI yang disederhanakan dan alasannya: `docs/refactoring-decisions.md`.
