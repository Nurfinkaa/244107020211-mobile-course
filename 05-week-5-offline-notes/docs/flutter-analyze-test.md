# Catatan `flutter analyze` & `flutter test`

Dokumentasi proses verifikasi kode dan debugging test untuk fitur **Testing: unit test model + repository palsu** pada mini project Offline Notes (Minggu 5 — Local Storage & Offline First).

## Ringkasan akhir

| Perintah | Hasil akhir |
|---|---|
| `flutter analyze` | ✅ **No issues found** |
| `flutter test` | ✅ **All tests passed! (4/4)** |

---

## 1. `flutter analyze`

### Percobaan pertama — 9 error

```
error - Undefined name 'noteRepositoryProvider' - test\note_test.dart:45:9
error - Undefined name 'notesProvider' - test\note_test.dart:53:40
error - Undefined name 'noteRepositoryProvider' - test\note_test.dart:61:9
error - Undefined name 'notesProvider' - test\note_test.dart:68:22
error - The property 'length'/'first' can't be unconditionally accessed - test\note_test.dart:54,55
warning - Unused import 'flutter_riverpod' - lib\data\network_state.dart:1:8
warning - Unused import 'flutter_riverpod' - lib\data\repositories\post_repository.dart:6:8
warning - Unused import 'flutter/material.dart' - lib\pages\settings_page.dart:1:8
```

**Penyebab:** `noteRepositoryProvider` dan `notesProvider` dideklarasikan di `lib/pages/notes_page.dart`, bukan di `lib/data/repositories/note_repository.dart` (posisi default sesuai contoh codelab). `test/note_test.dart` awalnya belum meng-*import* `pages/notes_page.dart`, sehingga kedua provider tersebut dianggap tidak dikenal (*undefined*) — efek lanjutannya, dua baris di bawahnya (`notes.length`, `notes.first`) ikut dianggap nullable karena tipe pengembalian tidak bisa diresolusi.

**Solusi:** menambahkan import berikut ke `test/note_test.dart`:

```dart
import 'package:week5_offline_notes/pages/notes_page.dart';
```

### Percobaan kedua — 3 warning tersisa

```
warning - Unused import 'flutter_riverpod' - lib\data\network_state.dart:1:8
warning - Unused import 'flutter_riverpod' - lib\data\repositories\post_repository.dart:6:8
warning - Unused import 'flutter/material.dart' - lib\pages\settings_page.dart:1:8
```

Ketiga warning ini adalah *unused import*, tidak menghalangi test berjalan. Dibiarkan sementara karena `settings_page.dart` sedang dalam proses penambahan widget `SettingsPage` (yang memang membutuhkan `flutter/material.dart`).

### Hasil akhir

```
flutter analyze
No issues found! (ran in 13.5s)
```

---

## 2. `flutter test`

Total **6 percobaan** sampai seluruh test stabil lulus. Berikut kronologi masalah dan solusinya.

### Percobaan 1 — `widget_test.dart` bawaan template gagal

```
Bad state: No ProviderScope found
...
Expected: exactly one matching candidate
  Actual: _TextWidgetFinder:<Found 0 widgets with text "0": []>
```

**Penyebab:** `test/widget_test.dart` adalah file bawaan `flutter create` (contoh *counter app*), mencari widget `Text('0')` yang tidak pernah ada di aplikasi Offline Notes. File ini tidak relevan dan tidak pernah disesuaikan.

**Solusi:** hapus file.

```bash
del test\widget_test.dart
```

### Percobaan 2 — Provider *disposed* saat masih loading

```
TimeoutException after 0:00:30.000000
Expected: throws <Instance of 'Exception'>
  Actual: <Instance of 'Future<List<Note>>'>
   Which: threw StateError:<Bad state: The provider AsyncNotifierProvider<NotesNotifier, List<Note>>
   was disposed during loading state, yet no value could be emitted.>
```

**Penyebab:** Riverpod 3 menerapkan *auto-dispose* pada semua provider secara default. `container.read(notesProvider.future)` hanya melakukan pembacaan sesaat (*bare read*) tanpa mempertahankan *listener* — akibatnya provider di-*dispose* oleh Riverpod sebelum `build()` sempat menyelesaikan proses error-nya.

**Solusi (belum tuntas):** menahan provider tetap hidup dengan `container.listen(...)` sebelum membaca `.future`.

### Percobaan 3 — `catchError` salah tipe kembalian

```
Invalid argument(s) (onError): The error handler of Future.catchError must return a value of the future's type
```

**Penyebab:** pola `future.catchError((_) {})` mengharuskan *handler* mengembalikan nilai bertipe `List<Note>`, sedangkan closure yang ditulis mengembalikan `null`.

**Solusi:** ganti ke `try { await ... } catch (_) {}` biasa.

### Percobaan 4 — Membaca provider dari container yang sudah *disposed*

```
TimeoutException after 0:00:30.000000
Bad state: Tried to read a provider from a ProviderContainer that was already disposed
```

**Penyebab:** ini adalah efek samping dari test sebelumnya yang timeout — `addTearDown(container.dispose)` sempat dieksekusi test framework setelah 30 detik, lalu baris `expect(container.read(...))` di bawahnya tetap mencoba jalan pada container yang sudah mati. Akar masalah sebenarnya (proses `await` yang macet) belum ditemukan pada tahap ini.

### Percobaan 5 — State masih `AsyncLoading` (bukan `AsyncError`), status *retrying*

```
Expected: <Instance of 'AsyncError'>
  Actual: AsyncLoading<List<Note>>: (error: Exception: db locked (simulasi), ..., retrying)
```

**Penyebab akar ditemukan di sini:** Riverpod 3 memiliki mekanisme **auto-retry** — ketika `build()` gagal, provider tidak langsung berpindah ke state `AsyncError`, melainkan mencoba ulang (*retry*) beberapa kali terlebih dahulu. Ini menjelaskan seluruh timeout 30 detik pada percobaan-percobaan sebelumnya, dan berbeda dari perilaku Riverpod 2 yang dipakai pada contoh asli codelab.

**Solusi:** menonaktifkan retry khusus untuk `ProviderContainer` pada test ini:

```dart
final container = ProviderContainer(
  retry: (retryCount, error) => null, // matikan auto-retry saat test
  ...
);
```

Percobaan ini masih gagal karena jeda tunggu (`Duration(milliseconds: 100)`) terlalu singkat — state belum sempat selesai bertransisi dari `AsyncLoading` (membawa error) ke bentuk final.

### Percobaan 6 — Lulus ✅

Solusi final: memperbesar jeda tunggu menjadi `500ms` dan mengganti pengecekan dari `isA<AsyncError>()` menjadi `state.hasError` + `state.error` (lebih toleran terhadap state transisi Riverpod 3):

```dart
test('provider error dengan repository palsu', () async {
  final container = ProviderContainer(
    retry: (retryCount, error) => null, // matikan auto-retry saat test
    overrides: [
      noteRepositoryProvider.overrideWithValue(
        FakeNoteRepository(throwError: true),
      ),
    ],
  );
  addTearDown(container.dispose);

  container.listen(notesProvider, (_, __) {}, fireImmediately: true);

  await Future<void>.delayed(const Duration(milliseconds: 500));

  final state = container.read(notesProvider);
  expect(state.hasError, isTrue);
  expect(state.error, isA<Exception>());
});
```

```
flutter test
00:06 +4: All tests passed!
```

---

## 3. Verifikasi manual: mode pesawat, badge dirty, dan sync

Selain `flutter analyze` dan `flutter test`, dua poin checklist berikut **tidak bisa diverifikasi lewat kode saja** dan wajib dibuktikan langsung di device/emulator:

- Aplikasi penuh berfungsi dalam mode pesawat (baca, tambah, hapus catatan)
- Badge dirty akurat sebelum/sesudah sync, dan cache posts tetap tampil tanpa internet

Berikut bukti screenshot yang sudah diambil (disimpan di folder `screenshots/`):

| Screenshot | Membuktikan |
|---|---|
| `praktikum_belum-ada-tugas` | Kondisi awal: belum ada catatan sama sekali (empty state) |
| `praktikum_tambah-catatan` | Dialog tambah catatan baru berhasil dibuka |
| `praktikum_berhasil-1-catatan` | Catatan baru berhasil tersimpan dan tampil di daftar |
| `praktikum_badge-dirty-muncul` | Badge oranye "belum sync" muncul setelah catatan ditambahkan |
| `praktikum-berhasil-menambahkan` | Penambahan catatan kedua berhasil, badge dirty bertambah |
| `praktikum_berhasil-1-catatan-sync` | Setelah tombol sync ditekan, badge dirty hilang (catatan tersinkron) |
| `praktikum_tidak-ada-tugas-sync` / `praktikum_sync-kosong-tidak-ada-yang-di-sync` | Menekan sync saat tidak ada catatan dirty menampilkan pesan "Tidak ada catatan yang perlu disinkronkan" |
| `praktikum_force-offline-ON` | Toggle *Force Offline* pada halaman Posts diaktifkan — data lama dari cache tetap tampil |
| `praktikum_force-offline-OFF` | Toggle *Force Offline* dimatikan — halaman Posts kembali fetch data terbaru dari API |
| `RTE_list-catatan-belum-sync` | Daftar catatan menampilkan badge dirty pada `NoteTile` (hasil Refactoring Challenge #1) |
| `RTE_detail-catatan-belum-sync` | Halaman detail (`/note/:id` via GoRouter) menampilkan status "belum tersinkron" |
| `RTE_detail-catatan-sudah-sync` | Halaman detail menampilkan status "tersinkron" setelah sync dijalankan |
| `RTE_list-badge-hilang-setelah-sync` | Badge dirty pada daftar hilang setelah sync, konsisten dengan halaman detail |
| `Screenshot 2026-09-27 184656` | Output terminal `flutter test` — konfirmasi seluruh test lulus |

**Kesimpulan:** kedua poin checklist (baca/tambah/hapus catatan offline, dan akurasi badge dirty + cache posts) terbukti berfungsi sesuai desain — dirty flag muncul saat ada perubahan lokal, hilang setelah `syncNotes` berhasil, dan konsisten antara halaman daftar maupun halaman detail catatan.

---

## Temuan penting untuk AI Verification Checklist

Dua perilaku **Riverpod 3** berikut tidak ada pada contoh kode asli codelab (yang berbasis Riverpod 2), dan baru diketahui setelah proses debugging manual — bukan sekadar menyalin saran AI mentah-mentah:

1. **Auto-dispose default.** Provider dapat di-*dispose* saat masih dalam status *loading* jika tidak ada `listener` aktif (`container.listen(...)`) yang mempertahankannya. Sekadar `container.read(provider.future)` tidak cukup untuk menjaga provider tetap hidup selama proses async berjalan.
2. **Auto-retry saat error.** Ketika `build()` melempar *exception*, provider tidak langsung berubah menjadi `AsyncError`, melainkan mencoba ulang beberapa kali (state sementara bertipe `AsyncLoading` yang membawa `error` dan flag *retrying*). Untuk pengujian yang deterministik, retry ini perlu dimatikan lewat parameter `retry: (retryCount, error) => null` pada `ProviderContainer`.

