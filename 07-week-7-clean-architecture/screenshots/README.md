# Screenshots — daftar bukti before/after

Screenshot **before** bisa memakai arsip minggu 5 di
`05-week-5-offline-notes/screenshots/`. Screenshot **after** diambil setelah
refactor saat uji manual ±5 menit per fitur. Simpan file di folder ini.

## Wajib

| File | Cara ambil |
|---|---|
| `after_notes_list.png` | Buka app: daftar catatan tampil (bandingkan dgn before `praktikum_berhasil-1-catatan.jpg`) |
| `after_notes_badge_dirty.png` | Tambah 1 catatan: badge "N belum sync" muncul (before: `praktikum_badge-dirty-muncul.jpg`) |
| `after_notes_synced.png` | Tekan ikon sync: snackbar "N catatan berhasil disinkronkan", badge hilang (before: `praktikum_list-badge-hilang-setelah-sync.jpg`) |
| `after_note_detail.png` | Tap catatan: halaman detail + status tersinkron (before: `RTE_detail-catatan-sudah-sync.jpg`) |
| `after_posts_online.png` | Buka Posts online 1x: daftar posts tampil |
| `after_posts_force_offline.png` | Force Offline ON: data tetap tampil dari cache (before: `praktikum_force-offline-ON.jpg`) |

## Hasil verifikasi terminal (lampirkan juga)

- Output tiga grep sterilitas (sudah tercatat di `README.md`)
- `flutter analyze` → No issues found!
- `flutter test` → All tests passed!
