# Tugas Minggu 2 — Declarative UI & Responsive Design

## Nama dan Identitas
Nurfinka — NIM 244107020211 — D4 Teknik Informatika

## Deskripsi Aplikasi
Aplikasi ini adalah halaman Academic Overview yang dibangun menggunakan Flutter. Halaman ini menampilkan header profil mahasiswa beserta empat kartu informasi akademik (Assignments, Attendance, Portfolio, dan Current week). Layout aplikasi bersifat responsif, menampilkan satu kolom pada layar sempit dan dua kolom pada layar lebar dengan breakpoint 700 piksel. Aplikasi juga menyediakan light theme dan dark theme yang dapat diubah melalui toggle CupertinoSwitch pada AppBar, serta dilengkapi label aksesibilitas menggunakan widget Semantics pada elemen-elemen penting seperti kartu informasi, header profil, dan tombol toggle tema.

## AI Prompt Challenge

### Prompt 1 — Perbandingan Layout
Prompt yang diajukan adalah membandingkan dua tata letak dashboard akademik untuk Flutter, yaitu versi GridView dan versi LayoutBuilder ditambah Column, beserta penjelasan trade-off dari sisi responsivitas dan aksesibilitasnya.

AI menjelaskan bahwa GridView lebih cepat digunakan untuk kartu-kartu yang seragam karena jumlah kolom bisa diatur otomatis melalui crossAxisCount, namun urutan pembacaan oleh screen reader mengikuti urutan grid secara baris demi baris sehingga bisa membingungkan jika layout tidak simetris. Sementara itu, LayoutBuilder yang dikombinasikan dengan Column memberikan kebebasan lebih dalam mengatur arah dan urutan elemen sesuai lebar layar, sehingga urutan pembacaan screen reader dapat dikontrol secara eksplisit, meskipun membutuhkan penulisan kode yang lebih panjang.

Keputusan yang saya ambil adalah tetap menggunakan kombinasi keduanya, yaitu LayoutBuilder untuk menentukan jumlah kolom berdasarkan lebar layar, kemudian GridView.count untuk menyusun kartu-kartu tersebut. Alasannya, kartu-kartu pada dashboard ini memiliki bentuk yang seragam sehingga GridView sudah cukup optimal, sementara LayoutBuilder tetap diperlukan untuk mengambil keputusan responsif mengenai jumlah kolom.

### Prompt 2 — Penguatan Konsep Expanded dan Overflow
Prompt yang diajukan adalah meminta penjelasan mengenai kapan penggunaan Expanded justru menyebabkan overflow di dalam Row, disertai contoh kode yang gagal dan cara memperbaikinya.

AI menjelaskan bahwa Expanded akan menyebabkan error apabila Row yang membungkusnya diletakkan pada tempat yang tidak memberikan batas lebar yang jelas, misalnya ketika sebuah Row diletakkan langsung di dalam Row lain tanpa dibungkus Expanded terlebih dahulu. Kesalahan ini menghasilkan pesan error RenderFlex children have non-zero flex but incoming width constraints are unbounded. Perbaikannya adalah dengan membungkus Row bagian dalam tersebut menggunakan Expanded, sehingga Row dalam mendapatkan batas lebar yang jelas dari parent-nya.

Setelah memeriksa kembali kode pada proyek ini, seluruh penggunaan Expanded berada langsung di dalam Row yang constraint-nya sudah jelas, yaitu di dalam Container pada ProfileHeader dan di dalam Card pada DashboardCard, sehingga tidak berisiko mengalami overflow seperti kasus yang dijelaskan.

### Prompt 3 — Verifikasi Rekomendasi Layout
Prompt yang diajukan adalah meminta AI memeriksa kembali rekomendasi layout yang telah diberikan, khususnya mengenai apakah layout tetap responsif di bawah 600 piksel, apakah mengurangi aksesibilitas, dan apakah ada widget yang tidak tersedia di Flutter stable saat ini.

Hasil audit menunjukkan bahwa layout tetap responsif di bawah 600 piksel karena breakpoint yang digunakan adalah 700 piksel, sehingga semua lebar di bawah angka tersebut secara konsisten menghasilkan satu kolom tanpa ada breakpoint tersembunyi lain yang berpotensi menyebabkan layout pecah. Dari sisi aksesibilitas, tidak ada penurunan karena Semantics telah dipasang pada CupertinoSwitch, ProfileHeader, dan setiap DashboardCard, meskipun perlu dicatat bahwa urutan pembacaan screen reader pada GridView dua kolom mengikuti urutan baris, bukan per kolom. Semua widget yang digunakan, yaitu LayoutBuilder, GridView.count, Expanded, Container, Semantics, dan CupertinoSwitch, merupakan bagian dari Flutter SDK stable dan tidak ada yang bersifat eksperimental.

## Bukti Verifikasi
Pengujian widget test dijalankan menggunakan perintah flutter test dan menghasilkan tiga pengujian yang seluruhnya lulus, yaitu pengujian tampilan satu kolom pada layar sempit, pengujian tampilan dua kolom pada layar lebar, dan pengujian fungsi toggle tema dari terang ke gelap. Screenshot kondisi layar sempit disimpan pada file screenshots/sempit.png dan screenshot kondisi layar lebar disimpan pada file screenshots/lebar.png sebagai bukti bahwa layout responsif berfungsi sesuai ketentuan.