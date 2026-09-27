
**AI assistant yang digunakan:** Claude

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

## Refleksi

Untuk project Offline Notes minggu ini, kombinasi **SharedPreferences (preferensi)
+ sqflite (catatan)** yang sudah diimplementasikan sudah tepat sesuai kebutuhan
skala project. Migrasi ke Drift baru relevan jika aplikasi berkembang menjadi
lebih kompleks (misalnya menambahkan relasi kategori/tag pada catatan, atau
membutuhkan reaktivitas otomatis tanpa perlu `invalidateSelf()` manual di
setiap operasi CRUD).