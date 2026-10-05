# Campus Notify (Minggu 6: Authentication, Security & FCM)

## Tujuan
Aplikasi notifikasi kampus dengan login, penyimpanan token aman, dan FCM
dengan deep link ke halaman pengumuman.

## Fitur utama
- Login (mock auth) dengan guard route GoRouter
- Token di `flutter_secure_storage`; Dio refresh otomatis sekali saat 401, logout bila refresh gagal
- FCM: permission, `getToken` + `onTokenRefresh`, topik `pengumuman-kampus`
- Notifikasi `notification + data`; klik membuka `/pengumuman/:id` di tiga app state
- Rute terpusat di `lib/routes.dart`, pesan error ramah di `lib/data/api_errors.dart`

## Stack
Flutter, Riverpod, GoRouter, Dio, flutter_secure_storage,
firebase_messaging, flutter_local_notifications

## Cara menjalankan
```
flutter pub get
flutter analyze
flutter test
flutter run
```

Setup Firebase: taruh `google-services.json` di `android/app/` (tidak di-commit).
Untuk uji notifikasi, kirim campaign dari Firebase Console dengan Custom data
`route` = `/pengumuman/3` dan `id` = `3`. Gunakan data seluler bila Wi-Fi memblokir FCM.

## Endpoint backend (contoh)
```
POST /devices  body: {"fcm_token": "...", "platform": "android"}
```
Backend contoh tidak tersedia, sehingga request ini gagal (ditangkap `try/catch`, aplikasi tidak crash).

## Hasil uji tiga app state
Payload yang sama: `notification` + `data.route = /pengumuman/3`.

| State | Hasil | Bukti banner | Bukti halaman tujuan |
|---|---|---|---|
| Foreground | OK: banner lokal muncul (`_local.show`), klik masuk ke `/pengumuman/3` | `screenshots/foreground-banner.jpg` | `screenshots/foreground-tujuan.jpg` |
| Background | OK: banner sistem muncul, klik masuk ke `/pengumuman/3` | `screenshots/background-banner.jpg` | `screenshots/background-tujuan.jpg` |
| Terminated | OK: dibuka dari notifikasi, masuk ke `/pengumuman/3` via `getInitialMessage` | `screenshots/terminated-banner.jpg` | `screenshots/terminated-tujuan.jpg` |

Bukti kondisi Terminated (aplikasi benar-benar ditutup sebelum notifikasi dikirim):
`screenshots/terminated-1-sebelum-ditutup.jpg` dan `screenshots/terminated-2-sudah-ditutup.jpg`.

## Galeri screenshot

| File | Isi |
|---|---|
| `screenshots/fcm-console-test.jpg` | Campaign percobaan dari Firebase Console |
| `screenshots/login-home.jpg` | Halaman login dan Home setelah login |
| `screenshots/foreground-banner.jpg` | Foreground: banner lokal |
| `screenshots/foreground-tujuan.jpg` | Foreground: halaman Pengumuman 3 |
| `screenshots/background-banner.jpg` | Background: banner sistem |
| `screenshots/background-tujuan.jpg` | Background: halaman Pengumuman 3 |
| `screenshots/terminated-banner.jpg` | Terminated: banner sistem |
| `screenshots/terminated-tujuan.jpg` | Terminated: halaman Pengumuman 3 |
| `screenshots/terminated-1-sebelum-ditutup.jpg` | Aplikasi terbuka sebelum ditutup |
| `screenshots/terminated-2-sudah-ditutup.jpg` | Aplikasi sudah ditutup dari recent apps |
| `screenshots/flutter-analyze-test.jpg` | Hasil `flutter analyze` dan `flutter test` |

Catatan perangkat: Android, **[ISI: merek/tipe HP]**, diuji dengan data seluler.
Wi-Fi tempat kost memblokir FCM (tidak ada log `onMessage`), dan uji Terminated
dilakukan dengan menutup aplikasi lewat recent apps tanpa `flutter run` ulang.
iOS tidak diuji.

## Pengujian
`flutter analyze` bersih dan `flutter test` lulus 11 test: parsing rute
(`routeFromMessage`), konstanta `AppRoutes`, pemetaan error (`friendlyMessage`),
serta logika sesi token dan refresh. Bukti: `screenshots/flutter-analyze-test.jpg`.

## Dokumentasi
- `docs/03-verifikasi-dan-perbaikan.md`: prompt, draf AI, checklist verifikasi, perbaikan manual, keputusan final
- `docs/04-refleksi.md`: jawaban pertanyaan refleksi
- Branch `coba-draf-ai` (commit `3594def`): eksperimen memakai draf AI apa adanya

## Hasil yang dicapai
Sudah jalan: login mock dengan guard route, penyimpanan token aman, refresh
otomatis saat 401, permission + token FCM + topik, banner dan deep link di tiga
app state, serta test dan analyze yang lulus.

Belum atau terbatas:
- `POST /devices` belum terhubung ke backend nyata (endpoint hanya didokumentasikan).
- Alur `onTokenRefresh` setelah reinstall/clear data belum diuji secara menyeluruh.
- Login masih mock, belum Firebase Auth.
- iOS belum diuji (butuh APNs key dan perangkat iOS).

## Refleksi

**1. Mengapa refresh token tidak boleh disimpan di SharedPreferences? Apa risikonya bila bocor?**
SharedPreferences menyimpan data sebagai teks biasa tanpa enkripsi, sehingga bisa terbaca lewat perangkat yang di-root, backup perangkat, atau malware. `flutter_secure_storage` memakai Keystore (Android) dan Keychain (iOS) sehingga terenkripsi. Refresh token berumur panjang (7 hari di codelab); bila bocor, penyerang bisa terus meminta access token baru tanpa kata sandi sampai token dicabut atau kedaluwarsa. Access token yang bocor jauh lebih kecil dampaknya karena hanya hidup sekitar 15 menit.

**2. Apa yang rusak bila `onTokenRefresh` diabaikan selama satu semester?**
Token FCM bisa berubah (reinstall, clear data, rotasi keamanan). Bila perubahan tidak dikirim ke backend, backend terus mengirim ke token lama yang tidak valid. Pesan tidak pernah sampai tanpa error yang terlihat oleh mahasiswa, sehingga pengumuman penting seperti kelas dibatalkan tidak diterima sebagian pengguna, dan database menumpuk token basi.

**3. Kapan memakai topik dan kapan token perangkat?**
- **Topik** untuk broadcast yang isinya sama untuk satu kelompok. Contoh: "Kuliah Pemrograman Mobile hari ini ditiadakan" (satu kelas), libur kampus (semua mahasiswa), info kegiatan satu UKM.
- **Token perangkat** untuk pesan personal. Contoh: nilai UTS, tagihan UKT, pengingat jadwal bimbingan skripsi. Topik tidak cocok karena siapa pun yang berlangganan menerima pesannya, sehingga data pribadi bisa terkirim ke orang yang salah.

**4. Bagian mana dari draf AI yang ditolak atau diperbaiki, dan mengapa?**
- `getInitialMessage` dipanggil sebelum status login selesai dibaca: diperbaiki dengan menunggu `authStateProvider.future` agar guard GoRouter tidak membelokkan rute ke `/login` pada state Terminated.
- Variabel global `pendingDeepLink`: diganti callback `onTap` agar klik banner foreground langsung berpindah halaman tanpa state global yang bisa basi.
- Parameter posisional di `initialize` dan `show`: diganti parameter bernama sesuai versi `flutter_local_notifications` yang terpasang.
- Izin Android 13+: ditambah `requestNotificationsPermission()` dan `POST_NOTIFICATIONS` di manifest karena tanpa izin runtime banner tidak tampil.
- Rute dibaca langsung dari `data['route']`: dipisah ke `routeFromMessage` agar bisa diunit-test dan aman untuk rute kosong atau tanpa `/`.

Draf AI cukup untuk kerangka, tetapi perilaku di tiga app state dan urutan inisialisasi tetap harus dibuktikan lewat uji di perangkat.