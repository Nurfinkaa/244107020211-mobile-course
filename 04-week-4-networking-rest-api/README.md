# Week 4 - Networking & REST API

Aplikasi Flutter yang menampilkan daftar data dari REST API dummy (JSONPlaceholder), dibangun sebagai tugas Minggu 4 mata kuliah Pemrograman Aplikasi Mobile.

## AI Verification Checklist

Temuan verifikasi terhadap kode yang dibantu AI (`CommentRepository`, model `Comment`) sebelum diterima:

| Pertanyaan | Temuan |
|---|---|
| Apakah UI memanggil Dio secara langsung, atau lewat repository? | Lewat repository. Semua akses data comment melalui `commentRepositoryProvider` dan `commentsProvider`, tidak ada widget yang mengimpor `dio` secara langsung. |
| Apakah `fromJson` aman null, atau masih memakai cast langsung yang bisa crash? | Aman null. `Comment.fromJson` mengecek tipe tiap field dengan `is` sebelum cast, fallback ke `0`/`''` jika field hilang atau bertipe salah. Sudah diuji lewat `test/comment_test.dart`. |
| Apakah semua tipe `DioExceptionType` (timeout, connectionError, badResponse) dipetakan ke pesan pengguna? | Ya, dipetakan di `network_errors.dart`: timeout, connectionError, badResponse (dengan pembagian 404/401/403/lainnya), dan default case untuk error tak terduga. |
| Apakah `baseUrl`/timeout terpusat di satu client, bukan tersebar di tiap method? | Ya. AI awalnya menyarankan timeout diatur ulang per-repository; ini diubah agar `CommentRepository` menerima `Dio` yang sama dari `dioProvider`, sehingga konfigurasi tetap terpusat di `api_client.dart`. |
| Apakah test AI benar-benar menguji field hilang, atau hanya happy path? | Awalnya hanya kasus field hilang. Ditambahkan 1 edge case manual: field dengan tipe yang salah (`postId` sebagai String, `name` sebagai int) untuk memastikan tidak crash. |
| Hasil `flutter analyze` dan `flutter test`? | `flutter analyze`: **No issues found!**. `flutter test`: **6 test, semua pass** (setelah `test/widget_test.dart` bawaan default yang tidak relevan dihapus). |

Detail lengkap prompt, output AI, dan alasan tiap perbaikan ada di [`docs/ai-challenge.md`](docs/ai-challenge.md).

Refleksi Teknis

### 1. Mengapa UI Dilarang Memanggil Dio Secara Langsung?
* **Pemisahan Tanggung Jawab (*Separation of Concerns*):** Menjaga kode UI tetap bersih dari logika parsing JSON, konfigurasi request, dan error handling HTTP.
* **Testability:** Mengurangi ketergantungan langsung (*tight coupling*). Dengan mengabstraksikan akses data ke dalam `PostRepository`, pengujian (unit testing) dapat dijalankan menggunakan data tiruan (`FakePostRepository`) tanpa perlu koneksi jaringan asli.
* **Maintainability:** Jika struktur endpoint atau mekanisme networking berubah di kemudian hari, perubahan cukup dilakukan di lapisan repository tanpa perlu mengubah puluhan file UI.

---

### 2. Pagination: Client-Side vs Server-Side
* **Client-Side:** Cukup digunakan pada dataset berukuran kecil hingga sedang (di bawah ratusan item). Data diambil sekali di awal, kemudian dipecah (*slice*) secara lokal di memori.
* **Server-Side (`_page` & `_limit`):** Wajib diterapkan pada dataset besar atau yang terus bertambah. Pendekatan ini menghemat bandwidth dan mempercepat *initial load time* karena hanya mengambil data sesuai kebutuhan halaman saat itu (merepresentasikan kondisi nyata API produksi).

---

### 3. Penanganan Error: Otomatis vs `try/catch` Eksplisit
* **Otomatis via Riverpod:** Exception yang dilempar di dalam siklus `build()` pada `AsyncNotifier` secara otomatis ditangkap oleh Riverpod dan diubah menjadi state `AsyncValue.error`. UI cukup memanfaatkan `.when(loading:, error:, data:)`.
* **Kebutuhan `try/catch` Eksplisit:** Tetap wajib digunakan pada aksi manual di luar `build()`, seperti pada `loadNextPage()` atau `refresh()`. Tujuannya agar saat request tambahan gagal, data yang sudah berhasil dimuat sebelumnya tidak hilang dari layar.

---

### 4. Evaluasi & Perbaikan Output AI
Berdasarkan catatan pada `docs/ai-prompt-challenge.md`, terdapat 4 perbaikan utama terhadap kode awal yang dihasilkan AI:
1. **Dependency Injection:** Mengubah `CommentRepository` agar menerima instance `Dio` melalui constructor alih-alih melakukan inisiasi `Dio()` baru, guna mendukung konfigurasi terpusat dan *mock testing*.
2. **Robust Type & Null-Safety:** Memperbaiki deserialisasi `Comment.fromJson` agar kebal terhadap *crash* saat menemui nilai `null` atau tipe data yang tidak sesuai.
3. **Standarisasi Pesan Error:** Mengintegrasikan helper `friendlyErrorMessage()` yang mencakup seluruh spektrum `DioExceptionType` menggantikan error handler parsial bawaan AI.
4. **Kelengkapan Unit Test:** Menambahkan unit test secara mandiri beserta skenario *edge case* yang terlewat pada luaran AI.
lihat detail di `docs/ai-challenge.md`.*

## Bukti Pengujian (Screenshots)

### 1. Loading State
![Loading](screenshots/loading.JPG)

### 2. Success State — Internet Normal
Daftar 100 post berhasil dimuat dari `GET /posts`.

![Success - daftar awal](screenshots/success-list.JPG)
![Success - scroll sampai post ke-100](screenshots/success-scrolled-100.JPG)

### 3. Error State — Mode Pesawat (Connection Error)
Internet dimatikan (mode pesawat), tombol refresh ditekan, muncul pesan ramah pengguna + tombol "Coba lagi".

![Error - mode pesawat](screenshots/error-airplane-mode.JPG)

### 4. Error State — baseUrl Salah
`baseUrl` di `api_client.dart` diubah sementara menjadi URL yang tidak ada, untuk menguji penanganan connection error.

![Kode baseUrl diubah sementara](screenshots/kode-baseurl-salah.PNG)
![Error - baseUrl salah](screenshots/error-wrong-baseurl.JPG)

> Catatan: `baseUrl` sudah dikembalikan ke `https://jsonplaceholder.typicode.com` setelah pengujian selesai.

### 5. Pagination (Infinite Scroll)
Data bertambah otomatis saat scroll mendekati akhir list, tanpa reload penuh, dan berhenti saat data habis.

![Pagination - memuat halaman berikutnya](screenshots/pagination-loading-more.JPG)
![Pagination - semua data termuat](screenshots/pagination-complete.JPG)

### 6. Hasil Testing
`flutter test` dan `flutter analyze` dijalankan setelah `test/widget_test.dart` bawaan default dihapus.

![flutter test & flutter analyze](screenshots/flutter-analyze-dan-test.PNG)

## Hasil yang Dicapai

- Aplikasi berhasil menampilkan data dari REST API dengan penanganan 4 state (loading, error, empty, success).
- Pagination infinite scroll berjalan tanpa request ganda, ditandai guard `isLoadingMore` dan `hasMore` pada notifier.
- Semua error jaringan (timeout, connection error, 404, 401/403, 500) ditampilkan sebagai pesan yang ramah pengguna, bukan pesan teknis mentah.
- Unit test untuk parsing model (`fromJson` dengan field hilang) dan provider (dengan fake repository, tanpa koneksi internet asli) berhasil lulus.
- Kode telah melalui proses refactoring: ekstraksi widget (`PostTile`), sentralisasi fungsi error (`network_errors.dart`), dan penambahan halaman detail post.

## Catatan Penggunaan AI

Sebagian kode repository layer (`CommentRepository`, model `Comment`) dibuat dengan bantuan AI coding assistant, kemudian diverifikasi dan disesuaikan secara manual. Detail prompt, hasil awal AI, dan perbaikan yang dilakukan didokumentasikan di [`docs/ai-challenge.md`](docs/ai-challenge.md).