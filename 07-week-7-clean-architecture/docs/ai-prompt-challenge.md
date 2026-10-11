# AI Prompt Challenge — Week 7

## Prompt yang dipakai (ke asisten AI)

> Project Flutter: `week5_offline_notes` (lanjutan Minggu 5, di-copy ke
> `07-week-7-clean-architecture`). Kondisi: `lib/{data,pages,widgets}`,
> repository konkret tanpa interface (`class NoteRepository`,
> `class PostRepository`), entity `Note` membawa `toMap/fromMap`, provider
> mendefinisikan `NoteRepository()`/`PostRepository()` di dalam file page,
> exception mentah tampil di UI, belum ada `lib/core` atau `lib/features`.
>
> Tugas:
> 1. Usulkan struktur feature-first Clean Architecture untuk fitur notes +
>    posts.
> 2. Untuk tiap file lama sebutkan tujuan barunya (pindah/pecah/hapus).
> 3. Tandai bagian yang over-engineering bila diterapkan ke CRUD sederhana,
>    dan kapan use case benar-benar dibutuhkan vs repository langsung.
> 4. Tunjukkan wiring DI dengan Riverpod tanpa package DI tambahan.
> 5. Jelaskan trade-off setiap keputusan.
>
> Batasan: jangan mengubah file dulu; keputusan final diambil manusia.

## Ringkasan jawaban AI (usulan awal)

1. Struktur `core/` + `features/{notes,posts}/{domain,data,presentation}`
   dengan `routes.dart` terpisah (sesuai modul).
2. Pemetaan per-file: entity murni + `NoteModel`, interface `NoteRepository`
   di domain + `NoteRepositoryImpl` di data, use case `GetNotes`/`SyncNotes`,
   hapus `note_hive.dart`, `settings_page.dart`, `prefs.dart` (dead code),
   `FutureBuilder` di detail diganti `FutureProvider.family`.
3. Over-engineering yang ditandai AI: use case untuk CRUD satu-baris.
4. Wiring DI terpusat di `*_providers.dart` per fitur.
5. Trade-off tiap keputusan: lihat tabel di `refactoring-decisions.md`.

## Catatan

Prompt awal analisis (audit project lama + rencana refactor bertahap dengan
titik commit) disimpan di riwayat percakapan asisten; isinya konsisten dengan
dokumen ini. Keputusan final dan penyederhanaannya didokumentasikan di
`docs/refactoring-decisions.md`, dan hasil verifikasi grep-nya di
`docs/ai-verification-checklist.md`.
