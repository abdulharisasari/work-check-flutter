# WorkCheckApp - Flutter Project

Dokumentasi ini menjelaskan cara menjalankan project Flutter ini dengan **endpoint API lokal** sesuai IP PC Anda.

---

## 1. Clone Project

Clone repository ke komputer Anda:

```bash
git clone https://github.com/abdulharisasari/work-check-flutter.git
```

Terus masuk ke direktory file anda misal :

```bash
cd work-check-flutter
```

## 2. Instalasi Dependency

Instal semua dependency Flutter:

```bash
flutter pub get
```

---

## 3. Cek IP Lokal PC

Untuk memastikan device/emulator bisa terhubung ke backend lokal:

1. Buka Command Prompt / PowerShell.
2. Jalankan:

```bash
ipconfig
```

3. Cari bagian **IPv4 Address**, misal:

```
192.168.1.10
```

Ini akan menjadi endpoint API lokal Anda.

---

## 4. Konfigurasi Endpoint API Lokal

Buka file environment, misal:

```
lib/env/env.dev.dart
```

Ubah endpoint API menjadi IP lokal Anda, contohnya:

```dart
const String API_BASE_URL = 'http://10.219.221.59:3000';
```

> Pastikan backend API berjalan di PC Anda dan dapat diakses dari device/emulator yang sama.

---

## 5. Jalankan Project

Pastikan device/emulator terhubung ke jaringan yang sama dengan PC Anda, lalu jalankan:

```bash
flutter run
```

---

## 6. Koneksi Database (Backend)

* Koneksi database dilakukan **di backend**, bukan di Flutter.
* Pastikan backend sudah terhubung ke database dan berjalan di IP lokal yang sama.
* Flutter hanya akan mengakses endpoint API yang sudah dikonfigurasi.

---

## 7. Troubleshooting

Jika API tidak bisa diakses, periksa:

1. Firewall PC tidak memblokir port backend.
2. Backend listen di semua interface (0.0.0.0), bukan hanya localhost.
3. Device/emulator bisa melakukan ping ke IP PC Anda:

```bash
ping 10.219.221.59
```

4. Pastikan endpoint API di environment Flutter sesuai dengan IP backend.

---
## 8. Versi Flutter 

Berikut adalah versi yang digunakan

Flutter 3.16.5 
Tools • Dart 3.2.3 

## 9. Catatan

* Gunakan **device fisik** atau emulator yang terhubung ke jaringan yang sama dengan PC untuk testing.
* Semua data offline akan disimpan di Hive dan otomatis tersinkron saat koneksi tersedia.

