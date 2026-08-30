# Mini assignment
Buat aplikasi Profil Mahasiswa berdasarkan praktikum. Tambahkan NIM dan satu informasi tambahan menggunakan widget dasar. Push hasil ke repository portfolio sesuai struktur yang ditentukan. Sertakan screenshot dan penjelasan singkat atas satu kendala setup yang Anda temui.

## Kendala 
Kendala utama yang saya temui adalah saat pertama kali menyambungkan HP fisik lewat USB, perangkat terdeteksi namun berstatus "not authorized". Solusinya adalah membuka HP dan mengizinkan (allow) dialog otorisasi USB debugging yang muncul di layar.

# Refleksi

## 1. Kapan native lebih tepat dipilih daripada cross-platform?
Native lebih cocok kalau aplikasinya butuh performa tinggi banget, misalnya game atau aplikasi yang sering pakai fitur khusus HP (kamera, sensor, dll). Native juga lebih pas kalau aplikasinya memang cuma buat satu jenis HP aja, misal khusus iPhone saja.

## 2. Bagaimana perubahan state berhubungan dengan widget tree dan UI deklaratif?
Di Flutter, tampilan itu ngikutin data (state) yang ada. Kalau datanya berubah, Flutter otomatis gambar ulang tampilannya sesuai data baru. Jadi kita cukup ubah datanya aja, nggak perlu repot-repot ubah tampilan manual satu-satu.

## 3. Mengapa commit kecil dengan pesan jelas bermanfaat bagi pekerjaan tim dan portfolio?
Commit kecil dan jelas bikin orang lain (atau kita sendiri nanti) gampang paham perubahan apa yang dibuat. Kalau ada error, juga lebih gampang dicari letak kesalahannya. Buat portfolio, commit yang rapi juga nunjukin proses belajar kita step by step, nggak cuma hasil akhirnya doang.