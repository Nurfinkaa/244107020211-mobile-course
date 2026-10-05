# Tabel uji tiga app state

Payload sama untuk semua state: `notification{title, body}` + `data{route: /pengumuman/3, id: 3}`.
Pengiriman dari Firebase Console (Messaging, Notifications, target App, Scheduling Now), jaringan data seluler.
Perangkat: V2310 (Android). ✏️ Isi merek dan versi Android.

| State | Yang diharapkan | Hasil | Bukti |
|---|---|---|---|
| Foreground | Banner lokal muncul, klik masuk ke `/pengumuman/3` | Lulus | `screenshots/foreground-banner.jpg`, `screenshots/foreground-tujuan.jpg`, log `onMessage diterima`, `Banner lokal ditampilkan`, `Banner lokal diklik, payload: /pengumuman/3` |
| Background | Banner sistem muncul, klik masuk ke rute yang benar | Lulus | `screenshots/background-banner.jpg` (panel notifikasi, 6.32), `screenshots/background-tujuan.jpg` (Pengumuman 3, 6.34) |
| Terminated | Aplikasi terbuka ke rute yang benar via `getInitialMessage` | Lulus | `screenshots/terminated-2-sudah-ditutup.jpg` (recent apps kosong, 6.38), `screenshots/terminated-banner.jpg`, `screenshots/terminated-tujuan.jpg` (6.44) |

Handler yang bekerja: Foreground memakai `onMessage` (+ local notification manual), Background memakai `onMessageOpenedApp`, Terminated memakai `getInitialMessage`.