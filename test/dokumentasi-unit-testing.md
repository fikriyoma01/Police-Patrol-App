# Dokumentasi Unit Testing Police Patrol Management System

## Tujuan
Unit testing ini bertujuan untuk memastikan bahwa model-model utama dalam Police Patrol Management System berfungsi dengan benar, terutama dalam hal konversi data antara objek dan format JSON/Map.

## Struktur Testing
Testing dibagi menjadi empat grup utama, masing-masing berfokus pada satu model:
1. Incident Model Test
2. PatrolReport Model Test
3. PatrolRoute Model Test
4. Officer Model Test

## Detail Testing

### 1. Incident Model Test

#### Test Case 1: Incident can be created from JSON
**Tujuan**: Memastikan bahwa objek Incident dapat dibuat dengan benar dari data JSON.
**Metode**: 
- Membuat Map JSON dengan data insiden.
- Menggunakan `Incident.fromJson()` untuk membuat objek Incident.
- Memeriksa apakah properti-properti objek sesuai dengan data input.

#### Test Case 2: Incident can be converted to JSON
**Tujuan**: Memastikan bahwa objek Incident dapat dikonversi ke format JSON dengan benar.
**Metode**:
- Membuat objek Incident dengan data tertentu.
- Menggunakan metode `toJson()` untuk mengkonversi ke JSON.
- Memeriksa apakah hasil konversi sesuai dengan data awal.

### 2. PatrolReport Model Test

#### Test Case 1: PatrolReport can be created from Map
**Tujuan**: Memastikan bahwa objek PatrolReport dapat dibuat dengan benar dari data Map.
**Metode**:
- Membuat Map dengan data laporan patroli.
- Menggunakan `PatrolReport.fromMap()` untuk membuat objek PatrolReport.
- Memeriksa apakah properti-properti objek sesuai dengan data input.

#### Test Case 2: PatrolReport can be converted to Map
**Tujuan**: Memastikan bahwa objek PatrolReport dapat dikonversi ke format Map dengan benar.
**Metode**:
- Membuat objek PatrolReport dengan data tertentu.
- Menggunakan metode `toMap()` untuk mengkonversi ke Map.
- Memeriksa apakah hasil konversi sesuai dengan data awal.

### 3. PatrolRoute Model Test

#### Test Case 1: PatrolRoute can be created from JSON
**Tujuan**: Memastikan bahwa objek PatrolRoute dapat dibuat dengan benar dari data JSON.
**Metode**:
- Membuat Map JSON dengan data rute patroli, termasuk lokasi.
- Menggunakan `PatrolRoute.fromJson()` untuk membuat objek PatrolRoute.
- Memeriksa apakah properti-properti objek sesuai dengan data input, termasuk lokasi.

#### Test Case 2: PatrolRoute can be converted to JSON
**Tujuan**: Memastikan bahwa objek PatrolRoute dapat dikonversi ke format JSON dengan benar.
**Metode**:
- Membuat objek PatrolRoute dengan data tertentu, termasuk lokasi.
- Menggunakan metode `toJson()` untuk mengkonversi ke JSON.
- Memeriksa apakah hasil konversi sesuai dengan data awal, termasuk lokasi.

### 4. Officer Model Test

#### Test Case 1: Officer can be created from JSON
**Tujuan**: Memastikan bahwa objek Officer dapat dibuat dengan benar dari data JSON.
**Metode**:
- Membuat Map JSON dengan data petugas.
- Menggunakan `Officer.fromJson()` untuk membuat objek Officer.
- Memeriksa apakah properti-properti objek sesuai dengan data input.

#### Test Case 2: Officer can be converted to JSON
**Tujuan**: Memastikan bahwa objek Officer dapat dikonversi ke format JSON dengan benar.
**Metode**:
- Membuat objek Officer dengan data tertentu.
- Menggunakan metode `toJson()` untuk mengkonversi ke JSON.
- Memeriksa apakah hasil konversi sesuai dengan data awal.

