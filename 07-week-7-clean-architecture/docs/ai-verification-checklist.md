# AI Verification Checklist — Week 7

Hasil verifikasi usulan AI sebelum diterima. Semua pemeriksaan dilakukan
dengan grep/analyze, bukan membaca sekilas. Dijalankan 12 Okt 2026 pada
`07-week-7-clean-architecture`.

| # | Butir verifikasi | Hasil | Bukti |
|---|---|---|---|
| 1 | Interface repository di `domain`, implementasi di `data` | LULUS | `lib/features/notes/domain/repositories/note_repository.dart` (abstract) vs `lib/features/notes/data/repositories/note_repository_impl.dart`; sama untuk posts |
| 2 | `domain` bebas import Flutter/Dio/SQLite/Firebase | LULUS | `rg -n "import 'package:flutter\|import 'package:dio\|import 'package:sqflite\|import 'package:firebase" lib/features/notes/domain lib/features/posts/domain lib/core` → nol hasil (exit 1) |
| 3 | Tidak ada use case untuk CRUD satu-baris | LULUS | Use case hanya 3: `GetNotes`, `SyncNotes` (aturan bisnis: countDirty → upload → markAllSynced), `GetPosts` (cache-first + fallback). `addNote/deleteNote/fetchNoteById/readCachedPosts` langsung repository → notifier; alasannya di `refactoring-decisions.md` |
| 4 | Entity bebas mapping (`toMap/fromMap/toJson` hanya di model) | LULUS | `lib/features/notes/domain/entities/note.dart` dan `posts/domain/entities/post.dart` murni field; mapping ada di `data/models/note_model.dart` & `post_model.dart` |
| 5 | Wiring DI terpusat; widget tidak `new Repository()` | LULUS | `rg -n "Repository\(\|Dio\(BaseOptions" lib/pages lib/providers` → folder lama sudah tidak ada; instansiasi hanya di `features/*/presentation/providers/*_providers.dart` sebagai provider |
| 6 | Keputusan final dibuat manusia, boleh beda dari saran AI | LULUS | Tabel usulan-vs-keputusan-final: `docs/refactoring-decisions.md` |

## Hasil verifikasi akhir modul

```
# 1. Presentation steril dari data mentah (NOL hasil)
$ rg -n "Dio\(|openDatabase|getDatabasesPath|FlutterSecureStorage|SharedPreferences\.getInstance|jsonDecode" lib/features/notes/presentation lib/features/posts/presentation
exit=1

# 2. Domain steril dari framework & package (NOL hasil)
$ rg -n "import 'package:flutter|import 'package:dio|import 'package:sqflite|import 'package:firebase" lib/features/notes/domain lib/features/posts/domain lib/core
exit=1

# 3. Static analysis + test
$ flutter analyze
No issues found!
$ flutter test
00:01 +14: All tests passed!
```
