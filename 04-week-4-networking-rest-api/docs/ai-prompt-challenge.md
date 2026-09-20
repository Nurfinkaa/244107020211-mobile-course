# AI Challenge — Dokumentasi

Dokumen ini mencatat prompt yang digunakan, hasil awal dari AI coding assistant, perbaikan/verifikasi yang dilakukan secara manual, serta alasan keputusan teknis, sesuai arahan AI Verification Checklist pada codelab Minggu 4.

## Tools yang digunakan

Claude (AI coding assistant)

## Prompt yang digunakan

```
Buatkan repository layer Flutter untuk endpoint GET /comments?postId={id}
dari JSONPlaceholder menggunakan Dio + flutter_riverpod.
Requirements:
- Model Comment dengan fromJson aman null (postId, id, name, email, body).
- CommentRepository dengan method fetchComments(postId) + timeout 10 detik.
- AsyncNotifierProvider dengan penanganan error otomatis (AsyncError)
  dan fungsi pesan error
  ramah pengguna untuk timeout, connection error, 404, dan 500.
- Satu unit test untuk fromJson dengan field yang hilang.
Jelaskan setiap bagian kode dalam komentar.
```

## Hasil awal dari AI

AI menghasilkan:
- Class `Comment` dengan `fromJson` yang mengecek tipe data tiap field menggunakan `is` sebelum melakukan cast (`json['name'] is String ? json['name'] as String : ''`), sebagai alternatif dari pola `as String? ?? ''` yang dicontohkan di materi. Kedua pola sama-sama aman terhadap field yang hilang atau bertipe salah.
- Class `CommentRepository` dengan method `fetchComments(postId)` yang memanggil `GET /comments` dengan `queryParameters: {'postId': postId}`.
- Saran agar timeout diatur langsung pada instance Dio yang digunakan (bukan per-method), supaya konsisten dengan `PostRepository` yang sudah ada.
- Draf unit test untuk `Comment.fromJson` dengan field yang hilang.

## Perbaikan / penyesuaian manual yang dilakukan

1. **Timeout tidak diatur ulang di `CommentRepository`.** AI awalnya menyarankan menambahkan konfigurasi timeout di level repository. Ini diubah agar `CommentRepository` menerima instance `Dio` yang sama dari `dioProvider` (lewat `commentRepositoryProvider`), sehingga timeout dan base URL tetap terpusat di `api_client.dart`, sesuai aturan arsitektur "konfigurasi jaringan hidup di satu tempat" pada materi. Jika setiap repository mengatur timeout sendiri, perubahan konfigurasi di masa depan harus dilakukan di banyak tempat dan rawan tidak konsisten.
2. **Menambahkan `toJson()` pada model `Comment`** agar konsisten dengan model `Post`, meskipun tidak wajib karena aplikasi ini hanya membaca data (tidak mengirim data comment ke server).
3. **Memverifikasi `CommentRepository` tidak menangkap exception secara diam-diam** — exception dari Dio dibiarkan naik ke provider agar otomatis menjadi `AsyncError`/ditangani lewat `FutureProvider.family`, sesuai pola yang sudah diterapkan pada `PostRepository`.
4. **Memakai kembali `friendlyErrorMessage` yang sudah ada** di `network_errors.dart`, alih-alih membuat fungsi pesan error baru khusus komentar seperti yang disarankan AI. Ini menghindari duplikasi logic pemetaan error yang sudah menangani timeout, connection error, 404, dan 401/403/500.

## Verifikasi checklist (AI Verification Checklist)

- [x] UI tidak memanggil Dio secara langsung — akses data lewat `commentRepositoryProvider` dan `commentsProvider`.
- [x] `fromJson` aman null — diverifikasi lewat `test/comment_test.dart` (test "fromJson aman terhadap field yang hilang").
- [x] Semua tipe `DioExceptionType` yang relevan (timeout, connectionError, badResponse) dipetakan ke pesan pengguna lewat `friendlyErrorMessage`.
- [x] `baseUrl`/timeout terpusat di satu client (`api_client.dart`), tidak tersebar di tiap repository.
- [x] Ditambahkan kasus edge tambahan di luar happy path: `test/comment_test.dart` menguji field dengan tipe salah (`postId` dikirim sebagai String, `name` sebagai int) untuk memastikan tidak crash dan fallback ke nilai default.
- [x] `flutter test` dijalankan dan lulus: **6 test, semua pass** (output: `00:07 +6: All tests passed!`).
- [x] `flutter analyze` dijalankan dan hasilnya bersih: **No issues found!**

## Kesimpulan

AI membantu mempercepat penulisan boilerplate (model, repository, provider), tetapi keputusan arsitektural penting — seperti sentralisasi konfigurasi Dio dan penggunaan ulang fungsi error yang sudah ada — tetap diverifikasi dan disesuaikan secara manual agar konsisten dengan pola yang sudah dibangun di `PostRepository`.