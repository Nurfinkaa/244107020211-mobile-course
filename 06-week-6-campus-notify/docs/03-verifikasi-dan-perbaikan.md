# Verifikasi AI dan perbaikan manual

## AI Verification Checklist

| # | Pertanyaan | Hasil | Bukti / catatan |
|---|---|---|---|
| 1 | Background handler berupa fungsi top-level dengan `@pragma('vm:entry-point')`? | Ya | `firebaseMessagingBackgroundHandler` ada di level file, bukan method kelas. Didaftarkan lewat `registerBackgroundHandler()` sebelum `runApp`. |
| 2 | `onTokenRefresh` benar-benar mengirim token baru ke backend, bukan hanya dicetak? | Kode sudah benar, belum dibuktikan | `onTokenRefresh.listen(onToken)` memanggil callback yang melakukan `POST /devices`. Backend contoh tidak ada, jadi request gagal (ditangkap `try/catch`). ✏️ Uji reinstall/clear data dan catat hasilnya jika sempat. |
| 3 | Foreground memakai local notification manual? | Ya, terbukti | `onMessage` memanggil `_local.show`. Log: `onMessage diterima`, `Banner lokal ditampilkan`. Screenshot: `foreground-banner.png`. |
| 4 | Klik dari tiga state masuk ke rute benar? | Ya, ketiganya terbukti | Foreground, Background, dan Terminated masuk ke `/pengumuman/3`. Lihat tabel uji di README. |
| 5 | Token/secret tidak di-hardcode dan tidak di-log penuh? | Ya | Log hanya mencetak 12 karakter pertama (`dYp_GjgHQfCb...`). Tidak ada secret di kode. `google-services.json` tidak di-commit. ✏️ Pastikan tidak ada baris debug token penuh yang tertinggal. |

## Perbaikan manual terhadap draf AI

| Masalah pada draf | Perbaikan | Alasan teknis |
|---|---|---|
| `initialize` dan `show` memakai parameter posisional | Diganti parameter bernama (`settings:`, `id:`, `title:`, `body:`, `notificationDetails:`, `payload:`) | Sesuai API versi `flutter_local_notifications` yang terpasang |
| Variabel global `pendingDeepLink` | Diganti callback `onTap` pada `initLocalNotifications` | Klik banner foreground langsung berpindah halaman, tanpa state global yang bisa basi |
| Rute dibaca langsung dari `data['route']` | Dipisah ke fungsi murni `routeFromMessage` | Bisa diunit-test tanpa Firebase, menangani rute kosong atau tanpa `/` |
| `getInitialMessage` bisa dipanggil sebelum status login selesai dibaca | `handleTerminated` menunggu `authStateProvider.future` | Mencegah guard GoRouter membelokkan rute tujuan ke `/login` |
| Router tidak menjalankan ulang `redirect` saat status login berubah | Ditambah `refreshListenable` | Guard route bereaksi terhadap login/logout |
| Izin notifikasi Android 13+ hanya lewat `requestPermission` Firebase | Ditambah `requestNotificationsPermission()` dari plugin lokal dan `POST_NOTIFICATIONS` di `AndroidManifest.xml` | Android 13+ butuh izin runtime dan deklarasi manifest agar banner tampil |
| Manifest tidak punya `INTERNET` untuk build release | Ditambah `<uses-permission android:name="android.permission.INTERNET"/>` | Flutter hanya menyertakannya otomatis di mode debug |
| Kegagalan `_local.show` tidak terlihat | Dibungkus `try/catch` + log diagnosis | Memudahkan membedakan "pesan tidak sampai" dan "banner gagal tampil" |
| `widget_test.dart` bawaan masih menguji aplikasi counter | File dihapus | Test lama pasti gagal (tidak ada `ProviderScope`) dan tidak relevan |

## Bagian yang berbeda Android 13+ vs iOS, dan yang tidak boleh memakai BuildContext

- **Android 13+:** butuh `POST_NOTIFICATIONS` di manifest dan izin runtime. Banner foreground harus dibuat manual lewat `flutter_local_notifications`.
- **iOS:** butuh APNs key di Firebase Console dan capability Push di Xcode. Tidak diuji karena perangkat yang dipakai Android.
- **Tidak boleh memakai BuildContext atau Riverpod:** `firebaseMessagingBackgroundHandler`, karena berjalan di isolate terpisah. Navigasi dilakukan saat banner diklik.

## Temuan saat pengujian

1. **Jaringan Wi-Fi menahan FCM.** Pada Wi-Fi tempat kost, pesan dari console tidak sampai ke aplikasi (tidak ada log `onMessage`). Setelah Wi-Fi dimatikan dan memakai data seluler, pesan masuk. Banyak jaringan memblokir port FCM (5228 sampai 5230).
2. **Aplikasi ditutup lewat recent apps.** Pada perangkat dengan pembatasan latar belakang ketat, swipe-close kadang dianggap force-stop sehingga FCM tidak masuk. ✏️ Tulis langkah yang kamu pakai agar uji Terminated berhasil.
3. Pesan dari console untuk state Background dan Terminated ditampilkan **sistem** (bukan kode aplikasi), sedangkan state Foreground ditampilkan oleh kode lewat `_local.show`.

## Keputusan final dan alasan

- Pertahankan payload gabungan `notification + data`: `notification` untuk teks yang dibaca pengguna, `data.route` untuk deep link. Pesan hanya-data tidak ditampilkan otomatis oleh sistem.
- Pakai topik `pengumuman-kampus` untuk broadcast. Pesan personal (nilai, tagihan) seharusnya memakai token perangkat. 

## Penjelasan token lifecycle (untuk demo)

1. Aplikasi meminta izin notifikasi.
2. `getToken()` mengambil registration token perangkat.
3. Token dikirim ke backend (`POST /devices`) dan disimpan per pengguna.
4. Token bisa berubah (reinstall, clear data, rotasi keamanan), sehingga `onTokenRefresh` wajib didengarkan agar backend tidak menyimpan token basi.
5. Backend mengirim pesan ke token atau topik lewat FCM.