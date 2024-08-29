# Police Patrol App

Police Patrol App adalah aplikasi mobile yang dirancang untuk membantu petugas kepolisian dalam melakukan patroli, melaporkan insiden, dan mengoordinasikan kegiatan patroli secara efektif. Aplikasi ini memanfaatkan teknologi berbasis lokasi untuk melacak rute patroli, melaporkan insiden dengan bukti foto, dan memberikan laporan detail patroli.

Dokumentasi lengkap proyek: [sini](https://github.com/fikriyoma01/Police-Patrol-App/blob/main/doc/dokumentasi_proyek/Police%20Patrol%20Management%20System-skpl.docx.pdf)

## Fitur

- **Login dan Registrasi:** Pengguna dapat masuk dan membuat akun baru dengan pilihan peran (misalnya, Officer).
- **Dasbor Insiden:** Memungkinkan pengguna untuk melihat semua insiden yang telah dilaporkan, lengkap dengan detail waktu dan deskripsi insiden.
- **Peta Patroli:** Menampilkan peta interaktif yang menunjukkan lokasi pengguna saat ini, rute patroli yang telah diambil, dan lokasi insiden.
- **Pelaporan Insiden:** Fitur untuk melaporkan insiden dengan mengisi jenis insiden, deskripsi, dan mengambil foto bukti.
- **Laporan Patroli:** Menyediakan detail rute patroli yang diambil, termasuk waktu mulai dan akhir, jumlah personel, dan informasi terkait lainnya.
- **Obrolan Tim:** Fitur obrolan untuk berkomunikasi antar anggota tim patroli.

## Teknologi yang Digunakan

- **Flutter & Dart:** Digunakan untuk mengembangkan antarmuka pengguna dan logika aplikasi.
- **Firebase:** Digunakan untuk autentikasi, penyimpanan database (Firestore), penyimpanan cloud untuk media, dan layanan notifikasi push.
- **Google Maps API:** Untuk menampilkan peta interaktif dan melacak rute patroli.
- **GetX:** Library Flutter untuk manajemen status, routing, dan dependensi.
- **Unit Testing:** Menggunakan `flutter_test` untuk menguji model dan fungsi aplikasi.

## Instalasi

1. **Kloning Repositori:**

   ```bash
   git clone https://github.com/fikriyoma01/Police-Patrol-App.git
   cd Police-Patrol-App-main

2. **Install Dependencies:**

   ```bash
   flutter pub get

3. **Menjalankan Aplikasi**

   ```bash
   flutter run

## Tampilan project
![Fitur_preview](https://github.com/fikriyoma01/Police-Patrol-App/blob/main/doc/dokumentasi_proyek/Fitur_preview.png?raw=true)

![Fitur_preview_2](https://github.com/fikriyoma01/Police-Patrol-App/blob/main/doc/dokumentasi_proyek/Fitur_preview_2.png?raw=true)

