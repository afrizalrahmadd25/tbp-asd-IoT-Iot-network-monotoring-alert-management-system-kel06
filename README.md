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
     
