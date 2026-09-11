## Praktikum 3 — Uji Ketiga State

### Refleksi

**Mengapa menampilkan ulang data lama (stale data) dengan indikator refresh kadang lebih baik daripada mengosongkan layar?**

Menurut saya, menampilkan data lama itu berguna kalau data baru masih dalam proses dimuat, tapi bisa bikin bingung kalau datanya sudah tidak sesuai dengan kondisi terbaru. Makanya idealnya harus ada penanda yang jelas, seperti indikator refresh, agar user tahu bahwa data tersebut masih data lama.

**Kapan pola itu penting?**

Pola ini penting terutama untuk aplikasi seperti berita atau cuaca, di mana data nggak berubah drastis tiap detik. Jadi, menampilkan data lama sebentar nggak terlalu berisiko dibanding aplikasi seperti saldo pembayaran yang membutuhkan data selalu akurat secara real-time.

## AI Challenge 

Sebelum kode dari AI digunakan, saya melakukan pengecekan terhadap beberapa bagian implementasi.

**State diubah secara immutable**

State pada `todo_provider.dart` tidak diubah menggunakan `state.add()` atau mutasi list secara langsung. Perubahan state dibuat sebagai list baru menggunakan spread operator.

**Penggunaan `ref.watch` dan `ref.read`**

`ref.watch` digunakan di dalam `build` untuk memantau perubahan state, sedangkan `ref.read` digunakan pada callback seperti saat menambah, mengubah, dan menghapus tugas.

**Penanganan `AsyncValue`**

Ketiga kondisi `AsyncValue`, yaitu loading, error, dan data, sudah ditangani pada `stats_page.dart` menggunakan `statsAsync.when()`.

**Deklarasi Provider**

Provider seperti `todoListProvider`, `unfinishedTodoProvider`, dan `statsProvider` sudah memiliki deklarasi yang jelas dan tidak dibuat secara duplikat.

**Penggunaan API Riverpod**

Kode menggunakan pola `Notifier` untuk mengelola state dan `ConsumerWidget` pada halaman yang membutuhkan Riverpod. Tidak menggunakan `StateProvider` atau `StateNotifierProvider` untuk implementasi ini.

**Pengujian**

Kode diperiksa menggunakan `flutter analyze` dan `flutter test` untuk memastikan implementasi berjalan dengan baik dan tidak terdapat masalah pada kode.

### Refleksi

**1. Kapan `setState` masih cukup, dan kapan state harus naik ke Riverpod?**

`setState` masih cukup untuk data sederhana yang hanya digunakan dalam satu halaman. Kalau data perlu digunakan oleh beberapa widget atau halaman, lebih baik menggunakan Riverpod. Pada aplikasi ini saya menggunakan Riverpod untuk menyimpan daftar tugas agar state tetap ada saat berpindah halaman.

**2. Apa perbedaan `context.go` dan `context.push`, dan kapan masing-masing tepat digunakan?**

`context.go` digunakan untuk berpindah langsung ke route tertentu, sedangkan `context.push` menambahkan halaman baru ke navigation stack. Pada aplikasi ini saya menggunakan `context.go` untuk berpindah antara halaman ToDo dan Statistik melalui `NavigationBar`.

**3. Bagaimana `AsyncValue` mencegah bug dibanding tiga boolean terpisah?**

`AsyncValue` membuat kondisi loading, error, dan data menjadi satu state sehingga lebih mudah dikelola. Jika menggunakan tiga boolean terpisah, bisa terjadi kondisi yang tidak sesuai, misalnya loading dan error aktif bersamaan. Dengan `AsyncValue`, ketiga kondisi tersebut bisa ditangani dengan lebih jelas menggunakan `when()`.

**4. Bagian mana dari hasil AI yang Anda perbaiki, dan mengapa?**

Hasil dari AI tidak langsung saya gunakan semuanya. Saya menyesuaikan beberapa bagian seperti `TodoTile`, `unfinishedTodoProvider`, dan navigasi GoRouter dengan struktur aplikasi yang saya buat. Saya juga mengecek kembali widget test setelah melakukan perubahan agar kode yang digunakan sesuai dengan kebutuhan tugas dan tidak menyebabkan error.