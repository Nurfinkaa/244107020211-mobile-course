## Tugas utama
Kembangkan dashboard menjadi halaman Academic Overview dengan hasil seperi berikut ini 

# layar sempit

# layar lebar 

## AI Prompt Challenge
Menggunakan AI hanya untuk membandingkan dua alternatif tata letak.

## Prompt desain 
# Prompt:
"Untuk 4-5 kartu info dengan breakpoint sederhana, bandingkan GridView.count vs LayoutBuilder + Column/Wrap manual untuk dashboard akademik Flutter.

# Output penting:
GridView.count lebih ringkas dan otomatis mengatur spacing, tapi memaksa semua kartu punya childAspectRatio (rasio lebar:tinggi) yang sama. LayoutBuilder + Wrap lebih fleksibel karena tiap kartu bisa punya tinggi sesuai isinya sendiri, tapi kodenya lebih panjang.

# Yang saya verifikasi sendir
saya tambahkan kartu dengan teks value panjang ("Perlu revisi laporan praktikum minggu ini") ke GridView.count dengan childAspectRatio: 2.6. Hasilnya, teks terpotong karena tinggi kartu dibatasi rasio tetap tersebut — sesuai klaim AI. Saat saya ubah childAspectRatio ke 4.0, kartu jadi lebih pendek dan teks makin terpotong, membuktikan trade-off itu nyata, bukan asumsi AI semata.

# Keputusan yang saya pilih
Tetap pakai GridView.count, karena jumlah kartu dashboard saya kecil (5) dan seragam — trade-off rasio tetap tidak signifikan untuk isi kartu saat ini. Saya juga menambahkan overflow: TextOverflow.ellipsis pada InfoCard supaya teks panjang tidak crash, hanya terpotong rapi.

# Alasan teknis
Menjaga konsistensi visual antar kartu lebih penting daripada fleksibilitas tinggi per-kartu untuk use case ini; kalau nanti konten kartu makin bervariasi panjangnya, LayoutBuilder + Wrap jadi opsi yang lebih tepat.

## Verification prompt
Periksa kembali rekomendasi layout di atas: apakah tetap responsif di bawah 600px, apakah mengurangi aksesibilitas, dan apakah ada widget yang tidak tersedia di Flutter stabil saat ini?

# Prompt:
Jelaskan kapan penggunaan Expanded justru menyebabkan overflow di dalam Row, beri contoh kode yang gagal dan perbaikannya.

# Output penting:
Expanded bekerja dengan cara "meminjam" sisa ruang yang tersedia dari parent-nya (Row atau Column). Masalahnya muncul ketika Expanded digunakan di dalam widget yang tidak punya batas ukuran pasti pada sumbu yang sama — misalnya Column di dalam Column lain tanpa dibatasi tinggi, atau Row bersarang di dalam Row lain tanpa pembatas ukuran yang jelas. Flutter tidak tahu berapa ruang yang harus "dipinjamkan", sehingga muncul error RenderFlex overflowed by X pixels.

Kasus paling umum: meletakkan Expanded di dalam Row yang sebenarnya dibungkus oleh widget yang scroll secara horizontal (seperti SingleChildScrollView arah horizontal) — Expanded butuh batas lebar pasti, sedangkan area scroll dianggap "tak terbatas" ke arah tersebut.

# Contoh kode yang GAGAL (overflow)
// SALAH: Expanded dipakai di dalam Row yang berada di dalam
// SingleChildScrollView horizontal (area scroll = lebar "tak terbatas")
Widget buildGagal() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        Container(width: 100, color: Colors.red, child: const Text('A')),
        Expanded(  // <-- ERROR di sini: RenderFlex overflowed
          child: Container(color: Colors.blue, child: const Text('B')),
        ),
      ],
    ),
  );
}

# Versi yang SUDAH DIPERBAIKI
// BENAR: ganti Expanded dengan lebar pasti (SizedBox) 
// karena berada di area scroll horizontal
Widget buildBenar() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        Container(width: 100, color: Colors.red, child: const Text('A')),
        SizedBox(  // <-- ganti Expanded jadi SizedBox dengan lebar tetap
          width: 200,
          child: Container(color: Colors.blue, child: const Text('B')),
        ),
      ],
    ),
  );
}

# Contoh nyata dari project
di InfoCard, Expanded dipakai di dalam Row yang berada di dalam Card — ini aman, karena Card mendapat batas lebar pasti dari GridView.count (lewat childAspectRatio dan crossAxisCount), jadi Expanded tahu persis berapa ruang yang tersedia:
// AMAN: Row ini berada di dalam Card yang lebarnya sudah dibatasi
// oleh GridView.count (crossAxisCount menentukan lebar tiap kolom)
Row(
  children: [
    Expanded(child: Text(title)),  // aman, karena Card sudah punya lebar pasti
    Text(value, style: Theme.of(context).textTheme.headlineSmall,
        maxLines: 1, overflow: TextOverflow.ellipsis),
  ],
),

# Kesimpulan 
Expanded aman dipakai kalau parent langsungnya (Row/Column) sudah punya batas ukuran pasti pada sumbu yang sesuai. Expanded berbahaya kalau parent-nya berada di dalam area yang "tak terbatas" pada sumbu itu, seperti ListView/SingleChildScrollView yang scroll ke arah yang sama dengan Row/Column tersebut.

## Verification prompt. 
Minta AI mengaudit hasilnya sendiri: "Periksa kembali rekomendasi layout di atas: apakah tetap responsif di bawah 600px, apakah mengurangi aksesibilitas, dan apakah ada widget yang tidak tersedia di Flutter stabil saat ini?"

# Promt
Periksa kembali rekomendasi layout di atas: apakah tetap responsif di bawah 600px, apakah mengurangi aksesibilitas, dan apakah ada widget yang tidak tersedia di Flutter stabil saat ini?

# Output  
- Responsif di bawah 600px: aman — breakpoint 700px berarti di bawah itu otomatis 1 kolom, diverifikasi lewat widget test.
- Aksesibilitas: tidak berkurang — semua elemen penting (profil, toggle tema, kartu info) sudah diberi `Semantics`.
- Widget deprecated: tidak ditemukan — `GridView.count`, `LayoutBuilder`, `CupertinoSwitch`, dan `Semantics` semuanya masih stabil di Flutter saat ini.

# Keputusan yang dipilih:
Breakpoint dipertahankan di 700px (bukan 600px) karena hasil pengujian di beberapa ukuran layar emulator menunjukkan 700px memberi ruang yang lebih nyaman untuk kartu 2 kolom tanpa terasa sempit.

# Alasan teknis:
Nilai breakpoint bersifat desain, bukan aturan baku Flutter — 700px dipilih berdasarkan pengamatan visual langsung (eksperimen mengubah breakpoint ke nilai lain), bukan sekadar mengikuti rekomendasi default.

# Bukti verifikasi:
- `flutter analyze` → tidak ada error/warning.
- `flutter test` → dua widget test responsif (`test/dashboard_responsive_test.dart`) lulus: satu kolom di layar sempit, dua kolom di layar lebar. 

## Refactoring challenge
Setelah tugas utama berjalan, berikut adalah dokumentasi dari refactoring challange 

## Refleksi
1. Apa perbedaan cara berpikir imperative dan declarative saat membangun UI?
2. apan Expanded membantu dan kapan penggunaannya justru menghasilkan layout error?
3. Bagaimana breakpoint dan theme memengaruhi pengalaman pengguna?
4. Apa yang Anda verifikasi dari rekomendasi AI setelah tugas inti selesai