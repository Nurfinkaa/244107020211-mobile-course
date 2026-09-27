**AI assistant yang digunakan:** Claude

---

## Prompt yang digunakan

Prompt berikut diambil langsung dari bagian "AI Prompt Challenge" codelab Minggu 5,
dijalankan verbatim tanpa modifikasi:

```
Aplikasi Flutter Offline Notes: CRUD catatan + preferensi tema.
Bandingkan SharedPreferences, Hive, sqflite (SQLite), dan Drift
untuk dua kebutuhan ini. Requirements:
- Kriteria: kompleksitas query, kebutuhan relasi, reaktivitas (stream),
  type-safety, ukuran boilerplate, dan kemudahan testing.
- Beri rekomendasi final: mana untuk preferensi, mana untuk catatan,
  beserta alasannya dalam 1 tabel.
- Tunjukkan skema tabel/kotak untuk 1000+ catatan.
Jelaskan trade-off setiap pilihan.
```

---

## Hasil Perbandingan

| Kriteria | SharedPreferences | Hive | sqflite (SQLite) | Drift |
|---|---|---|---|---|
| Kompleksitas query | Tidak ada query, cuma key-value | Query sederhana (filter manual di Dart) | SQL penuh (JOIN, WHERE, GROUP BY, dll) | SQL penuh + query type-safe lewat Dart |
| Kebutuhan relasi | Tidak mendukung relasi | Tidak mendukung relasi native | Mendukung penuh (foreign key, JOIN) | Mendukung penuh + validasi relasi saat compile |
| Reaktivitas (stream) | Tidak ada, harus polling manual | Ada (`Box.watch()`) | Tidak native, perlu tools tambahan | Ada, native (`.watch()` di setiap query) |
| Type-safety | Rendah (semua lewat key String) | Sedang (perlu adapter/TypeAdapter) | Rendah (data mentah `Map<String, dynamic>`) | Tinggi (kode Dart digenerate dari skema) |
| Ukuran boilerplate | Sangat kecil | Sedang (perlu register adapter) | Sedang-besar (manual query & mapping) | Besar di awal (setup builder & code-gen), kecil setelahnya |
| Kemudahan testing | Mudah (bisa mock gampang) | Sedang | Sedang (butuh in-memory DB atau mock) | Mudah (query ter-generate, gampang di-mock) |

## Rekomendasi Final

| Kebutuhan | Rekomendasi | Alasan |
|---|---|---|
| Preferensi tema (dark mode, last opened) | **SharedPreferences** | Datanya cuma pasangan key-value sederhana (boolean, string), tidak butuh query maupun relasi. Pakai database untuk ini adalah over-engineering. |
| Catatan (CRUD + status dirty) | **sqflite** (untuk skala project ini), atau **Drift** untuk skala lebih besar | Butuh query (filter dirty, sort by updated_at) dan operasi CRUD terstruktur. sqflite cukup untuk kebutuhan saat ini; Drift lebih unggul jika butuh reaktivitas otomatis dan keamanan tipe data untuk project yang lebih besar. |

## Skema Tabel untuk 1000+ Catatan

```sql
CREATE TABLE notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  body TEXT NOT NULL DEFAULT '',
  updated_at TEXT NOT NULL,         -- ISO8601, untuk sorting & konflik LWW
  dirty INTEGER NOT NULL DEFAULT 1  -- 0 = synced, 1 = belum sync
);

CREATE INDEX idx_notes_updated_at ON notes(updated_at DESC);
CREATE INDEX idx_notes_dirty ON notes(dirty);
```

**Kenapa index penting di skala ini?** Tanpa index, query seperti `WHERE dirty = 1`
atau `ORDER BY updated_at DESC` melakukan *full table scan* (mengecek semua baris
satu per satu). Dengan index, database bisa langsung menuju baris yang relevan —
jauh lebih cepat, terutama untuk query badge dirty-count yang dipanggil setiap
kali UI rebuild.

## Trade-off Setiap Pilihan

- **SharedPreferences**: Sangat simpel, tapi tidak cocok untuk data terstruktur
  atau dalam jumlah besar — disimpan sebagai file XML/plist datar sehingga
  performanya buruk jika dipaksakan untuk data kompleks.
- **Hive**: Cepat untuk read/write key-value NoSQL dan reaktif secara native,
  tapi lemah untuk relasi antar data dan query kompleks (filter harus dilakukan
  manual di sisi Dart, bukan di level database).
- **sqflite**: Fleksibel penuh dengan SQL asli, tapi rawan bug karena query
  ditulis sebagai string mentah (kesalahan nama kolom baru terdeteksi saat
  runtime, bukan saat compile), dan tidak reaktif secara native.
- **Drift**: Paling aman dan powerful (type-safe, reaktif, mendukung migrasi
  skema dengan baik), namun setup awal lebih berat karena membutuhkan code
  generation dengan `build_runner`, sehingga terasa "berat" untuk project kecil
  seperti tugas ini.

---

## AI Verification Checklist

**1. Apakah AI menempatkan daftar catatan di SharedPreferences?**
Tidak — ditolak. Daftar catatan disimpan di tabel `notes` (sqflite), lihat
`lib/data/local/db.dart` dan `lib/data/repositories/note_repository.dart`.
SharedPreferences hanya dipakai untuk `dark_mode` dan `last_opened_at`, sesuai
batasan yang seharusnya untuk penyimpanan key-value primitif.

**2. Apakah skema AI mendukung antrean sync (dirty flag/updated_at), atau cuma CRUD polos?**
Mendukung. Skema di atas punya kolom `dirty` dan `updated_at`, dan keduanya
benar-benar dipakai di kode: `countDirty()`/`markAllSynced()` di
`NoteRepository` dan `syncNotes()` di `lib/data/sync.dart` untuk simulasi
antrean sync, plus `fetchNotes()` yang sort berdasarkan `updated_at DESC`.

**3. Apakah klaim "reaktif"/stream AI (terutama untuk Drift) didukung `.watch()`
sungguhan, atau cuma asumsi?**
Masih asumsi, belum diverifikasi. Project ini memakai sqflite, bukan Drift, jadi
baris "Ada, native (`.watch()` di setiap query)" pada tabel di atas berasal dari
pengetahuan umum AI dan belum pernah dicoba langsung. Belum instal Drift, belum
menjalankan `.watch()` secara nyata.

**4. Apakah estimasi boilerplate AI masuk akal setelah dicoba instalasinya sendiri
(`flutter pub add` + migrasi skema)?**
Untuk sqflite: sesuai — project ini memang butuh mapping manual (`toMap`/`fromMap`)
seperti disebut di tabel, terlihat di `lib/data/local/note.dart`. Untuk Hive dan
Drift: belum dicoba instalasi langsung di project ini, jadi baris boilerplate
keduanya di tabel di atas belum divalidasi dengan pengalaman nyata — masih klaim AI.

**5. Keputusan final + alasan (boleh berbeda dari rekomendasi AI):**
Diterima sesuai rekomendasi: SharedPreferences untuk preferensi, sqflite untuk
catatan. Alasan tambahan di luar tabel AI: SharedPreferences tidak cocok untuk
koleksi karena harus di-serialize jadi satu string JSON besar yang rapuh untuk
update parsial — bukan cuma soal performa, tapi juga risiko korupsi data kalau
proses berhenti di tengah penulisan. **Bagian yang ditolak dari rekomendasi AI:**
saran "Drift untuk skala lebih besar" di tabel Rekomendasi Final tidak diambil
untuk project ini — boilerplate awal (build_runner, codegen) tidak sebanding
manfaatnya untuk satu tabel sederhana; baru relevan kalau nanti benar-benar
perlu relasi (kategori/tag) atau reaktivitas otomatis lintas banyak query.

---

## Refleksi

Untuk project Offline Notes minggu ini, kombinasi **SharedPreferences (preferensi)
+ sqflite (catatan)** yang sudah diimplementasikan sudah tepat sesuai kebutuhan
skala project. Migrasi ke Drift baru relevan jika aplikasi berkembang menjadi
lebih kompleks (misalnya menambahkan relasi kategori/tag pada catatan, atau
membutuhkan reaktivitas otomatis tanpa perlu `invalidateSelf()` manual di
setiap operasi CRUD).