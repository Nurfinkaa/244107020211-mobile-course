/// Fungsi murni lintas fitur: parsing rute dan label teks.
/// Tidak boleh mengimpor Flutter agar bisa diuji sebagai unit biasa.
library;

/// Parsing parameter rute `/note/:id`; null bila id tidak valid.
int? parseNoteId(String? raw) => int.tryParse(raw ?? '');

/// Label badge jumlah catatan yang belum tersinkron.
String dirtyBadgeLabel(int count) => '$count belum sync';

/// Label status sinkronisasi pada halaman detail catatan.
String noteStatusLabel(bool dirty) =>
    dirty ? 'Status: belum tersinkron' : 'Status: tersinkron';
