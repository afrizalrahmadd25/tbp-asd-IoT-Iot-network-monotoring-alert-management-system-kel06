# KELOMPOK-6_Iot_Network_Monitoring_Alert_Management_System
topik-4 Iot Network Monitoring Alert Management System
# Team
  1. Afrizal Rahmad Dani 25051030002
  2. Muhammad Hanafi Aqillah Gustyawan 25051030004
  3. Aisyah Adielya Zahra 25051030026
  4. Yafi Dwi Pramuaji 25051030028
# Mata Kuliah
Algoritma dan Struktur Data
S1 Teknik Elektro
Universitas Negeri Yogyakarta
# Deskripsi Project
Project ini merupakan implementasi sistem manajemen IOT yang men-cover seluruh sistem IOT di gedung kampus Universitas Negeri Yogyakarta, menggunakan Bahasa Pemrograman PYTHON dan konsep Algoritma Struktur Data. Sistem dirancang untuk memudahkan pengelolaan sistem IOT di seluruh gedung kampus Universitas Negeri Yogyakarta, mencakup:
  1. Mengontrol 40 sensor (Suhu, kelembapan, CO2, daya listrik).
  2. Mengelola data termasuk ALERT sistem yaitu mengirim alert CRITICAL/WARNING/INFO secara bersamaan.
  3. Ternasuk dalam TOPOLOGI MESH yaitu GATEWAY sebagai titik agresi data menuju server pusat.
  4. Menggunakan sistem Routing yaitu menggunakan rute latensi minimum dari gateway ke setiap perangkat.
# Struktur Data Yang Digunakan
Sistem ini menggunakan Struktur data berupa:
  1. Graph (Adjacency List berbasis Linked List)
      -Digunakan untuk: Memodelkan topologi jaringan IoT
  2. Priority Queue (Singly Linked List Terurut)
      -Digunakan untuk: Antrian alert masuk dari sensor IoT.
  3. BST — Binary Search Tree (Device Registry)
      -Digunakan untuk: Menyimpan dan mencari data perangkat IoT secara cepat.
  4. Stack (AlertStack per-device, Singly Linked List)
      -Digunakan untuk: Menyimpan riwayat 20 alert terbaru untuk setiap perangkat secara LIFO.
  5. Dijkstra (menggunakan Graph + array sederhana)
      -Digunakan untuk: Mencari jalur dengan total latensi minimum dari GATEWAY_0 ke setiap perangkat dalam         jaringan.
  6. Selection Sort (pada Linked List)
     -Digunakan untuk: Mengurutkan daftar perangkat berdasarkan latensi ke gateway setelah Dijkstra               selesai, guna menghasilkan laporan audit yang terurut dari perangkat terdekat ke terjauh.
# Fitur Program
1. **ADD_DEVICE** — Menambahkan perangkat IoT baru (SENSOR/GATEWAY/SERVER) ke graph dan BST registry. `Big-O: O(1)`
2. **ADD_LINK** — Menambahkan koneksi berbobot (latensi ms) antara dua perangkat. `Big-O: O(1)`
3. **ALERT_IN** — Memasukkan alert (CRITICAL/WARNING/INFO) ke Priority Queue. CRITICAL selalu di depan. `Big-O: O(n)`
4. **PROCESS_ALERT** — Memproses alert paling prioritas dari antrian. `Big-O: O(1)`
5. **PENDING_ALERTS** — Menampilkan semua alert yang masih menunggu di antrian.
6. **HISTORY** — Menampilkan 20 riwayat alert terbaru per perangkat menggunakan Stack. `Big-O: O(n)`
7. **ROLLBACK_STATUS** — Membatalkan alert terakhir dan mengembalikan status perangkat. `Big-O: O(1)`
8. **CARI_DEVICE** — Mencari perangkat di BST berdasarkan device_id. `Big-O: O(log n)`
9. **UPDATE_STATUS** — Memperbarui status perangkat menjadi ONLINE/OFFLINE. `Big-O: O(log n)`
10. **ROUTING** — Mencari jalur latensi minimum dari GATEWAY_0 ke perangkat tujuan (Dijkstra). `Big-O: O(V²+E)`
11. **ISOLASI** — Mendeteksi perangkat yang tidak terjangkau dari GATEWAY_0 menggunakan DFS. `Big-O: O(V+E)`
12. **AUDIT_LATENSI** — Mengurutkan semua perangkat berdasarkan latensi ke gateway (Selection Sort). `Big-O: O(n²)`
13. **LAPORAN_JARINGAN** — Menampilkan ringkasan kondisi seluruh jaringan IoT.
14. **KELUAR** — Keluar dari program.

# Instalasi

```bash
git clone https://github.com/afrizalrahmadd25/tbp-asd-IoT-Iot-network-monotoring-alert-management-system-kel06.git
cd tbp-asd-IoT-Iot-network-monotoring-alert-management-system-kel06
pip install -r requirements.txt
```

# Cara Menjalankan
```bash
python src/main.py
```
# Pengujian
```bash
pytest tests/ -v
```
# Analisis Kompleksitas
| Operasi | Big-O Waktu | Big-O Ruang |
|---|---|---|
| add_device / add_link | O(1) | O(V+E) |
| enqueue alert | O(n) | O(n) |
| dequeue alert | O(1) | O(1) |
| BST insert/search | O(log n) avg | O(n) |
| DFS isolasi | O(V+E) | O(V) |
| Dijkstra routing | O(V²+E) | O(V) |
| Stack push/pop | O(1) | O(k) |
| Selection Sort | O(n²) | O(1) |
     
