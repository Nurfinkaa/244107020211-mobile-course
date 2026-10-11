# Usulan AI vs Keputusan Final — Week 7

Setiap baris: usulan awal AI, keputusan final (yang dieksekusi), dan alasan
teknis. Sesuai kebijakan AI modul: nilai ada pada justifikasi, bukan
kerapian folder.

| # | Topik | Usulan AI | Keputusan final | Alasan teknis |
|---|---|---|---|---|
| 1 | Basis project | week5 atau week6 | **week5** di-copy ke `07-week-7-clean-architecture/` | Entity `Note` week5 identik dengan contoh Praktikum 2 modul (adopsi kode minim risiko); week6 membawa FCM/firebase yang memperbesar risiko grep domain-steril. Poin 6 modul mengizinkan folder 07 |
| 2 | Nama package | bebas | **tetap `week5_offline_notes`** | Native code (Android `MainActivity.kt`, iOS, dll.) memakai applicationId dari nama package; rename = sentuh native + semua import test |
| 3 | Kontrak error | record Dart atau `Either` (fpdart) | **record Dart** `({notes, failure})` | Nol dependency tambahan; pola persis modul; `Either` menambah konsep + package tanpa kebutuhan nyata di project 2-fitur ini |
| 4 | Cakupan use case | tandai over-engineering CRUD satu-baris | **hanya `GetNotes`, `SyncNotes`, `GetPosts`** | `SyncNotes` = aturan bisnis nyata (countDirty → upload → markAllSynced); `GetPosts` = cache-first + fallback. `addNote/deleteNote/fetchNoteById` sengaja langsung repository→notifier — use case pass-through 5 baris hanya menambah biaya baca (modul & checklist AI menyebut eksplisit) |
| 5 | Model | `NoteModel extends Note` + `toEntity` | **diterima** | Pragmatis untuk skala ini; alternatif mapper terpisah menambah kode tanpa manfaat yang terasa |
| 6 | Dead code | hapus `note_hive.dart`; settings/prefs di luar scope atau dihapus | **ketiganya dihapus** | Tidak ber-rute → tidak pernah berjalan; `settings_page.dart` punya unused import yang mengotori `flutter analyze`; keputusan disetujui user |
| 7 | Detail page | ganti `FutureBuilder` | **`FutureProvider.family`** | Memperbaiki fetch ulang tiap build; state masuk AsyncValue (loading/error/data konsisten dengan halaman lain) |
| 8 | Navigasi posts | seragamkan routing | **`context.push('/posts')` + rute baru** | Sebelumnya `Navigator.push` manual di tengah app GoRouter — inkonsisten; perilaku visual sama (push) |
| 9 | `forceOfflineProvider` | pindah dari `data/` | **ke `features/posts/presentation/providers`** | State simulasi offline dipakai notifier posts; folder `data/` harus steril dari Riverpod presentation-state |
| 10 | `SyncNotes.uploadDelay` | delay tetap 1 detik | **dapat di-injeksi, default 1 detik** | Test use case jadi instan (`Duration.zero`); perilaku produksi tidak berubah |
| 11 | Error path UI | exception mentah | **SnackBar dengan `Failure.message`** | Refactoring Challenge #3: UI hanya menerima pesan ramah; sebelumnya error sqflite/Dio mentah tercetak atau crash tak tertangani |
| 12 | Pemilik `db.dart` | satu sumber `openNotesDb` | **di `features/notes/data/local/`, diimpor posts** | Satu file SQLite dibaca dua fitur (tabel `notes` + `cached_posts`); duplikasi skema lebih buruk daripada impor lintas data layer; dicatat sebagai trade-off |
| 13 | Rute invalid `/note/abc` | `int.parse` (crash) | **`parseNoteId` → fallback NotesPage** | `int.parse(...)!` melempar FormatException pada deep link rusak; `core/format.dart` (fungsi murni, teruji) membuat gagal graceful |

## Yang sengaja TIDAK dikerjakan (dan kenapa)

- **Use case per CRUD** — over-engineering; lihat baris 4.
- **Fitur settings** — tidak ber-rute sejak minggu 5; memolesnya di luar
  cakupan modul (modul mensyaratkan 1 fitur penuh + 1 fitur kedua).
- **Formatter tanggal di UI** — week5 tidak punya tanggal terformat di
  presentation sama sekali (grep `DateFormat` nol hasil); `core/format.dart`
  berisi parsing rute + label teks yang memang ada.
