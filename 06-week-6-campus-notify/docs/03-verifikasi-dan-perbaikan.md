# Verifikasi AI dan perbaikan manual

Dokumen ini mencatat AI Challenge Minggu 6: prompt, draf AI, hasil verifikasi, perbaikan manual, dan keputusan final.

- **Prompt:** prompt dari codelab (Campus Notification App, `PushService`).
- **Output awal AI:** `docs/push_service_draft_ai.dart`
- **Bukti eksperimen:** commit `3594def` di branch `coba-draf-ai` (tidak di-merge ke `main`).

> Bagian bertanda **[ISI: ...]** harus kamu lengkapi dari hasil pengamatan sendiri sebelum dikumpulkan.

## AI Verification Checklist

| # | Pertanyaan | Hasil | Bukti / catatan |
|---|---|---|---|
| 1 | Background handler berupa fungsi top-level dengan `@pragma('vm:entry-point')`? | Ya | `firebaseMessagingBackgroundHandler` ada di level file, bukan method kelas. Didaftarkan lewat `registerBackgroundHandler()` sebelum `runApp`. |
| 2 | `onTokenRefresh` benar-benar mengirim token baru ke backend, bukan hanya dicetak? | Kode benar, uji reinstall belum dilakukan | `onTokenRefresh.listen(onToken)` memanggil callback yang melakukan `POST /devices`. Backend contoh tidak ada, sehingga request gagal dan ditangkap `try/catch` (log: `Kirim token ke backend gagal: DioException`, aplikasi tidak crash). **[ISI: hasil uji reinstall/clear data, atau tulis "tidak diuji"]** |
| 3 | Foreground memakai local notification manual? | Ya, terbukti | `onMessage` memanggil `_local.show`. Log: `onMessage diterima`, `Banner lokal ditampilkan`. Screenshot: `screenshots/foreground-banner.png`. |
| 4 | Klik dari tiga state masuk ke rute benar? | Ya, ketiganya terbukti | Foreground, Background, dan Terminated masuk ke `/pengumuman/3`. Lihat tabel di bawah dan di README. |
| 5 | Token/secret tidak di-hardcode dan tidak di-log penuh? | Ya | Log hanya mencetak 12 karakter pertama (`dYp_GjgHQfCb...`). Tidak ada secret di kode. `google-services.json` tidak di-commit. Pengecekan: `Select-String -Path lib\*.dart,lib\**\*.dart -Pattern "getToken\|print\(\|debugPrint"` tidak menemukan pencetakan token penuh. **[ISI: konfirmasi hasil pengecekan]** |

### Tabel hasil uji 3 app state (kode utama)

| State | Banner | Penampil banner | Klik masuk ke | Sesuai |
|---|---|---|---|---|
| Foreground | Muncul | Kode aplikasi (`_local.show`) | `/pengumuman/3` | Ya |
| Background | Muncul | Sistem | `/pengumuman/3` | Ya |
| Terminated | Muncul | Sistem | `/pengumuman/3` | Ya |

## Perbaikan manual terhadap draf AI

| Masalah pada draf | Perbaikan | Alasan teknis |
|---|---|---|
| `initialize` dan `show` memakai parameter posisional | Diganti parameter bernama (`settings:`, `id:`, `title:`, `body:`, `notificationDetails:`, `payload:`) | Sesuai API versi `flutter_local_notifications` yang terpasang |
| Variabel global `pendingDeepLink` | Diganti callback `onTap` pada `initLocalNotifications` | Klik banner foreground langsung berpindah halaman, tanpa state global yang bisa basi |
| Rute dibaca langsung dari `data['route']` | Dipisah ke fungsi murni `routeFromMessage` di `lib/routes.dart` | Bisa diunit-test tanpa Firebase, menangani rute kosong atau tanpa `/` |
| `getInitialMessage` bisa dipanggil sebelum status login selesai dibaca | `handleTerminated` menunggu `authStateProvider.future` | Mencegah guard GoRouter membelokkan rute tujuan ke `/login` |
| Router tidak menjalankan ulang `redirect` saat status login berubah | Ditambah `refreshListenable` | Guard route bereaksi terhadap login/logout |
| Izin notifikasi Android 13+ hanya lewat `requestPermission` Firebase | Ditambah `requestNotificationsPermission()` dari plugin lokal dan `POST_NOTIFICATIONS` di `AndroidManifest.xml` | Android 13+ butuh izin runtime dan deklarasi manifest agar banner tampil |
| Manifest tidak punya `INTERNET` untuk build release | Ditambah `<uses-permission android:name="android.permission.INTERNET"/>` | Flutter hanya menyertakannya otomatis di mode debug |
| Kegagalan `_local.show` tidak terlihat | Dibungkus `try/catch` + log diagnosis | Memudahkan membedakan "pesan tidak sampai" dan "banner gagal tampil" |
| `widget_test.dart` bawaan masih menguji aplikasi counter | File dihapus | Test lama pasti gagal (tidak ada `ProviderScope`) dan tidak relevan |

## Refactoring dan testing

| Perubahan | Lokasi | Manfaat |
|---|---|---|
| String rute dipusatkan di `AppRoutes` | `lib/routes.dart` | Deep link FCM dan GoRouter memakai konstanta yang sama |
| `routeFromMessage(Map<String, dynamic>)` jadi fungsi murni | `lib/routes.dart` | Diuji tanpa Firebase |
| Pemetaan `DioException` ke pesan ramah (401, 403, 5xx, timeout, offline) | `lib/data/api_errors.dart` (`friendlyMessage`) | UI menerima pesan, bukan exception mentah |

Hasil akhir: `flutter analyze` bersih dan `flutter test` lulus 11 test (parsing rute, konstanta rute, pemetaan error, logika sesi token).

## Bagian yang berbeda Android 13+ vs iOS, dan yang tidak boleh memakai BuildContext

- **Android 13+:** butuh `POST_NOTIFICATIONS` di manifest dan izin runtime. Banner foreground harus dibuat manual lewat `flutter_local_notifications`.
- **iOS:** butuh APNs key di Firebase Console dan capability Push di Xcode. Tidak diuji karena perangkat yang dipakai Android.
- **Tidak boleh memakai BuildContext atau Riverpod:** `firebaseMessagingBackgroundHandler`, karena berjalan di isolate terpisah. Navigasi dilakukan saat banner diklik.

## Temuan saat pengujian

1. **Jaringan Wi-Fi menahan FCM.** Pada Wi-Fi tempat kost, pesan dari console tidak sampai ke aplikasi (tidak ada log `onMessage`). Setelah Wi-Fi dimatikan dan memakai data seluler, pesan masuk. Banyak jaringan memblokir port FCM (5228 sampai 5230).
2. **Aplikasi ditutup lewat recent apps.** Pada perangkat dengan pembatasan latar belakang ketat, swipe-close kadang dianggap force-stop sehingga FCM tidak masuk. Langkah yang membuat uji Terminated berhasil: **[ISI: langkah yang kamu pakai]**
3. Pesan dari console untuk state Background dan Terminated ditampilkan **sistem** (bukan kode aplikasi), sedangkan state Foreground ditampilkan oleh kode lewat `_local.show`.
4. `POST /devices` selalu gagal karena backend contoh bersifat palsu (`example-campus-api.test`). Ini diharapkan dan tidak mengganggu notifikasi dari Firebase Console.

## Keputusan final dan alasan

- **Draf AI tidak diadopsi ke `main`.** Kode utama tetap memakai `push_service.dart` buatan sendiri, dengan perbaikan manual di tabel di atas. Alasan: **[ISI: sesuaikan dengan hasil eksperimen, misalnya draf tidak menunggu status login sehingga klik Terminated berisiko ke `/login`, atau draf lebih sedikit kontrolnya atas urutan inisialisasi]**. Bukti eksperimen disimpan di branch `coba-draf-ai`.
- Pertahankan payload gabungan `notification + data`: `notification` untuk teks yang dibaca pengguna, `data.route` untuk deep link. Pesan hanya-data tidak ditampilkan otomatis oleh sistem.
- Pakai topik `pengumuman-kampus` untuk broadcast. Pesan personal (nilai, tagihan) seharusnya memakai token perangkat.

## Penjelasan token lifecycle (untuk demo)

1. Aplikasi meminta izin notifikasi.
2. `getToken()` mengambil registration token perangkat.
3. Token dikirim ke backend (`POST /devices`) dan disimpan per pengguna.
4. Token bisa berubah (reinstall, clear data, rotasi keamanan), sehingga `onTokenRefresh` wajib didengarkan agar backend tidak menyimpan token basi.
5. Backend mengirim pesan ke token atau topik lewat FCM.