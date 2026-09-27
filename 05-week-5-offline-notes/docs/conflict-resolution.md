# Aturan Resolusi Konflik Sinkronisasi

## Strategi yang digunakan: Last-Write-Wins (LWW)

Aplikasi ini menggunakan kolom `updated_at` (timestamp) pada setiap catatan
untuk menentukan pemenang saat terjadi konflik data.

**Aturan:** Versi catatan dengan `updated_at` PALING BARU akan disimpan.
Versi yang lebih lama akan ditimpa/diabaikan.

## Contoh skenario

1. Catatan "Belajar Flutter" dibuat jam 10:00, `updated_at = 10:00`
2. Pengguna edit di HP A jam 10:05 menjadi "Belajar Flutter Lanjutan",
   `updated_at = 10:05`, status `dirty = true`
3. Saat sync ke server, karena `updated_at` 10:05 lebih baru dari yang
   tersimpan di server (10:00), versi dari HP A yang disimpan.

## Kenapa strategi ini dipilih?

- **Sederhana untuk diimplementasikan** — cukup bandingkan satu timestamp.
- **Cocok untuk single-user** — aplikasi ini didesain untuk satu pengguna
  di satu perangkat aktif dalam satu waktu, sehingga risiko konflik nyata
  (dua edit bersamaan) sangat kecil.

## Kenapa aturan ini WAJIB didokumentasikan?

Tanpa aturan eksplisit, sinkronisasi dua arah (offline ke server, server
ke offline) bisa saling menimpa data **secara diam-diam** tanpa pemberitahuan
apa pun ke pengguna. Contoh bahaya:

- Perubahan offline yang sebenarnya lebih baru bisa tertimpa oleh data
  server yang lebih lama (kalau aturan salah arah / tidak konsisten).
- Pengguna tidak tahu bahwa perubahannya "hilang", karena tidak ada
  indikator atau log yang menjelaskan keputusan sinkronisasi.

Dengan mendokumentasikan LWW secara eksplisit, siapa pun yang membaca
project ini (termasuk pengembang di masa depan) tahu persis perilaku
sistem saat terjadi konflik, tanpa perlu menebak dari kode.

## Keterbatasan strategi ini

Last-Write-Wins **bukan solusi sempurna** untuk skenario multi-user atau
multi-device yang mengedit data yang sama secara bersamaan (concurrent
edit), karena:

- Versi yang "kalah" akan **hilang total**, bukan digabung (merge).
- Tidak ada riwayat/log yang menyimpan versi yang ditimpa.

Untuk kasus multi-user/multi-device yang lebih kompleks, dibutuhkan
strategi lebih canggih seperti **CRDT (Conflict-free Replicated Data
Type)** atau **operational transform** — di luar cakupan tugas ini.