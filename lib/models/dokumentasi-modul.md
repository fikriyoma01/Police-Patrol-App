# Dokumentasi Modul Police Patrol Management System

## 1. Modul User

### Deskripsi
Modul User merepresentasikan pengguna dalam sistem, termasuk petugas dan pusat komando.

### Kelas: User
- **Atribut:**
  - `id` (String): Identifikasi unik pengguna
  - `email` (String): Alamat email pengguna
  - `name` (String?): Nama pengguna (opsional)
  - `patrolUnit` (String?): Unit atau divisi patroli (opsional)
  - `profileImageUrl` (String?): URL gambar profil (opsional)
  - `lastOnlineTimestamp` (DateTime?): Waktu terakhir online
  - `role` (UserRole): Peran pengguna (Officer, CommandCenter)
  - `latitude` (double?): Latitude lokasi pengguna (opsional)
  - `longitude` (double?): Longitude lokasi pengguna (opsional)

- **Metode:**
  - `toJson()`: Mengkonversi objek User menjadi Map JSON
  - `fromJson(json)`: Membuat objek User dari Map JSON

### Enum: UserRole
- Nilai: Officer, CommandCenter

## 2. Modul Incident

### Deskripsi
Modul Incident menangani pelaporan dan pengelolaan insiden selama patroli.

### Kelas: Incident
- **Atribut:**
  - `id` (String): Identifikasi unik insiden
  - `latitude` (double): Latitude lokasi insiden
  - `longitude` (double): Longitude lokasi insiden
  - `description` (String): Deskripsi insiden
  - `timestamp` (DateTime): Waktu insiden terjadi
  - `reportedBy` (String?): ID pengguna yang melaporkan (opsional)
  - `type` (String?): Jenis insiden (opsional)
  - `mediaUrl` (String?): URL media terkait insiden (opsional)
  - `mediaType` (String?): Jenis media (opsional)
  - `patrolRouteId` (String?): ID rute patroli terkait (opsional)
  - `status` (IncidentStatus?): Status insiden

- **Metode:**
  - `toJson()`: Mengkonversi objek Incident menjadi Map JSON
  - `fromJson(json)`: Membuat objek Incident dari Map JSON

### Enum: IncidentStatus
- Nilai: Pending, Resolved, InProgress

## 3. Modul Officer

### Deskripsi
Modul Officer merepresentasikan petugas kepolisian yang melakukan patroli.

### Kelas: Officer
- **Atribut:**
  - `id` (String): Identifikasi unik petugas
  - `name` (String): Nama petugas
  - `rank` (String): Pangkat petugas
  - `patrolUnit` (String): Unit atau divisi patroli
  - `status` (String): Status petugas (On Duty, Off Duty, dll)

- **Metode:**
  - `toJson()`: Mengkonversi objek Officer menjadi Map JSON
  - `fromJson(json)`: Membuat objek Officer dari Map JSON

## 4. Modul PatrolReport

### Deskripsi
Modul PatrolReport menangani pembuatan dan pengelolaan laporan patroli.

### Kelas: PatrolReport
- **Atribut:**
  - `id` (String): Identifikasi unik laporan patroli
  - `officerId` (String): ID petugas yang membuat laporan
  - `warrantDateTime` (DateTime): Waktu surat perintah patroli
  - `typeOfPatrol` (String): Jenis patroli
  - `natureOfPatrol` (String): Sifat patroli
  - `isFootPatrol` (bool): Apakah patroli jalan kaki
  - `numberOfPersonnel` (int): Jumlah personel yang terlibat
  - `patrolRouteId` (String): ID rute patroli terkait

- **Metode:**
  - `toMap()`: Mengkonversi objek PatrolReport menjadi Map
  - `fromMap(map)`: Membuat objek PatrolReport dari Map

## 5. Modul PatrolRoute

### Deskripsi
Modul PatrolRoute menangani informasi tentang rute patroli yang dilakukan.

### Kelas: PatrolRoute
- **Atribut:**
  - `id` (String): Identifikasi unik rute patroli
  - `officerId` (String): ID petugas yang merekam rute
  - `startTime` (DateTime): Waktu mulai patroli
  - `endTime` (DateTime?): Waktu selesai patroli (opsional)
  - `locations` (List<LocationPoint>): Daftar titik lokasi yang direkam
  - `incidents` (List<Incident>?): Daftar insiden yang dilaporkan selama patroli (opsional)

- **Metode:**
  - `toJson()`: Mengkonversi objek PatrolRoute menjadi Map JSON
  - `fromJson(json)`: Membuat objek PatrolRoute dari Map JSON

### Kelas: LocationPoint
- **Atribut:**
  - `latitude` (double): Latitude titik lokasi
  - `longitude` (double): Longitude titik lokasi
  - `timestamp` (DateTime): Waktu perekaman titik lokasi

- **Metode:**
  - `toJson()`: Mengkonversi objek LocationPoint menjadi Map JSON
  - `fromJson(json)`: Membuat objek LocationPoint dari Map JSON

## 6. Modul Resource

### Deskripsi
Modul Resource menangani informasi tentang sumber daya yang digunakan dalam operasi kepolisian.

### Kelas: Resource
- **Atribut:**
  - `id` (String): Identifikasi unik sumber daya
  - `name` (String): Nama sumber daya
  - `type` (String): Jenis sumber daya (Mobil, Peralatan, Personel, dll)
  - `status` (String): Status sumber daya (Tersedia, Sedang Digunakan, Dalam Perbaikan, dll)

- **Metode:**
  - `toJson()`: Mengkonversi objek Resource menjadi Map JSON
  - `fromJson(json)`: Membuat objek Resource dari Map JSON

